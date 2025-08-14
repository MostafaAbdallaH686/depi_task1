#!/usr/bin/env python3

import argparse
import os
import sys
import textwrap
from typing import List, Optional, Tuple

import numpy as np
import pandas as pd

# Use a non-interactive backend to allow running headless
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import seaborn as sns


def parse_arguments() -> argparse.Namespace:
	parser = argparse.ArgumentParser(
		description="Quick EDA: summarize a CSV, check for missing/unusual values, and create plots.",
		formatter_class=argparse.RawDescriptionHelpFormatter,
		epilog=textwrap.dedent(
			"""
			Examples:
			  python eda/analyze_csv.py --path /workspace/data.csv
			  python eda/analyze_csv.py --path /workspace/data.csv --output-dir /workspace/eda_outputs --max-plots 12
			"""
		),
	)
	parser.add_argument("--path", required=True, help="Absolute path to the CSV file to analyze.")
	parser.add_argument("--output-dir", default="/workspace/eda_outputs", help="Directory to save outputs (plots and report).")
	parser.add_argument("--max-plots", type=int, default=12, help="Maximum number of plots per type to generate.")
	parser.add_argument("--sample-rows", type=int, default=0, help="Optional: sample this many rows for plotting if dataset is very large (0 = no sampling).")
	parser.add_argument("--delimiter", default=",", help="CSV delimiter (default ',').")
	parser.add_argument("--encoding", default=None, help="File encoding (auto-detect if not provided).")
	return parser.parse_args()


def ensure_output_directory(output_dir: str) -> None:
	os.makedirs(output_dir, exist_ok=True)


def try_read_csv(csv_path: str, delimiter: str, encoding: Optional[str]) -> pd.DataFrame:
	if not os.path.isfile(csv_path):
		raise FileNotFoundError(f"CSV not found: {csv_path}")
	read_kwargs = dict(sep=delimiter, low_memory=False)
	if encoding:
		read_kwargs["encoding"] = encoding
	try:
		return pd.read_csv(csv_path, **read_kwargs)
	except UnicodeDecodeError:
		# Fallback encodings
		for enc in ["utf-8", "utf-8-sig", "latin-1", "cp1252"]:
			try:
				return pd.read_csv(csv_path, **{**read_kwargs, "encoding": enc})
			except Exception:
				continue
		raise


def safe_to_datetime(series: pd.Series) -> pd.Series:
	try:
		converted = pd.to_datetime(series, errors="coerce", infer_datetime_format=True)
		return converted
	except Exception:
		return series


def detect_datetime_columns(df: pd.DataFrame) -> List[str]:
	datetime_columns: List[str] = []
	for column_name in df.columns:
		series = df[column_name]
		if series.dtype == "O":
			converted = safe_to_datetime(series)
			na_ratio = converted.isna().mean()
			# Consider as datetime if conversion succeeded for most values
			if na_ratio < 0.5 and (converted.notna().sum() > 0):
				datetime_columns.append(column_name)
	return datetime_columns


def summarize_dataframe(df: pd.DataFrame) -> str:
	num_rows, num_columns = df.shape
	memory_mb = df.memory_usage(deep=True).sum() / (1024 ** 2)
	lines = [
		f"Rows: {num_rows}",
		f"Columns: {num_columns}",
		f"Approx. memory usage: {memory_mb:.2f} MB",
		"",
		"Column types:",
	]
	dtype_counts = df.dtypes.value_counts()
	for dtype_name, count in dtype_counts.items():
		lines.append(f"  - {dtype_name}: {count}")
	return "\n".join(lines)


def compute_missing_values(df: pd.DataFrame) -> pd.DataFrame:
	missing_count = df.isna().sum()
	missing_percent = (missing_count / len(df)) * 100 if len(df) > 0 else 0
	missing_df = (
		pd.DataFrame({"missing_count": missing_count, "missing_percent": missing_percent})
		.sort_values(by=["missing_percent", "missing_count"], ascending=False)
	)
	return missing_df


def detect_unusual_values(df: pd.DataFrame) -> Tuple[pd.DataFrame, dict]:
	issues: dict = {}
	issues["duplicate_rows"] = int(df.duplicated().sum())

	constant_columns: List[str] = []
	for column_name in df.columns:
		unique_non_na = df[column_name].nunique(dropna=True)
		if unique_non_na <= 1:
			constant_columns.append(column_name)
	issues["constant_columns"] = constant_columns

	numeric_df = df.select_dtypes(include=[np.number])
	negative_value_columns: List[str] = []
	zero_only_columns: List[str] = []
	for column_name in numeric_df.columns:
		col = numeric_df[column_name]
		if (col < 0).any():
			negative_value_columns.append(column_name)
		if col.nunique(dropna=True) == 1 and (col.dropna().iloc[0] == 0 if col.dropna().size > 0 else False):
			zero_only_columns.append(column_name)
	issues["negative_value_columns"] = negative_value_columns
	issues["zero_only_columns"] = zero_only_columns

	# Outlier detection using IQR
	outlier_summary_records: List[dict] = []
	for column_name in numeric_df.columns:
		col = numeric_df[column_name].dropna()
		if col.size < 5:
			continue
		q1 = np.percentile(col, 25)
		q3 = np.percentile(col, 75)
		iqr = q3 - q1
		if iqr == 0:
			continue
		lower_bound = q1 - 1.5 * iqr
		upper_bound = q3 + 1.5 * iqr
		outlier_mask = (col < lower_bound) | (col > upper_bound)
		outlier_count = int(outlier_mask.sum())
		outlier_percent = (outlier_count / col.size) * 100
		outlier_summary_records.append(
			{
				"column": column_name,
				"outlier_count": outlier_count,
				"outlier_percent": outlier_percent,
				"q1": q1,
				"q3": q3,
				"lower_bound": lower_bound,
				"upper_bound": upper_bound,
			}
		)
	outlier_df = pd.DataFrame(outlier_summary_records).sort_values(by=["outlier_percent", "outlier_count"], ascending=False)
	return outlier_df, issues


def save_dataframe_preview(df: pd.DataFrame, output_dir: str) -> None:
	preview_path = os.path.join(output_dir, "preview.csv")
	df_head = df.head(50)
	df_head.to_csv(preview_path, index=False)


def maybe_sample(df: pd.DataFrame, sample_rows: int, random_state: int = 42) -> pd.DataFrame:
	if sample_rows and sample_rows > 0 and len(df) > sample_rows:
		return df.sample(n=sample_rows, random_state=random_state)
	return df


def plot_numeric_distributions(df: pd.DataFrame, output_dir: str, max_plots: int) -> List[str]:
	paths: List[str] = []
	numeric_cols = df.select_dtypes(include=[np.number]).columns.tolist()
	if not numeric_cols:
		return paths
	subset_cols = numeric_cols[:max_plots]
	cols = 3
	rows = int(np.ceil(len(subset_cols) / cols))
	plt.figure(figsize=(cols * 5, rows * 3.5))
	for idx, column_name in enumerate(subset_cols, start=1):
		plt.subplot(rows, cols, idx)
		sns.histplot(df[column_name].dropna(), kde=True, bins=30)
		plt.title(f"Histogram: {column_name}")
	plt.tight_layout()
	path = os.path.join(output_dir, "numeric_histograms.png")
	plt.savefig(path, dpi=150)
	plt.close()
	paths.append(path)

	# Boxplots
	plt.figure(figsize=(cols * 5, rows * 3.5))
	for idx, column_name in enumerate(subset_cols, start=1):
		plt.subplot(rows, cols, idx)
		sns.boxplot(x=df[column_name], orient="h")
		plt.title(f"Boxplot: {column_name}")
	plt.tight_layout()
	path = os.path.join(output_dir, "numeric_boxplots.png")
	plt.savefig(path, dpi=150)
	plt.close()
	paths.append(path)
	return paths


def plot_correlation_heatmap(df: pd.DataFrame, output_dir: str) -> Optional[str]:
	numeric_df = df.select_dtypes(include=[np.number])
	if numeric_df.shape[1] < 2:
		return None
	corr = numeric_df.corr(numeric_only=True)
	plt.figure(figsize=(min(1 + corr.shape[1] * 0.6, 18), min(1 + corr.shape[0] * 0.6, 12)))
	sns.heatmap(corr, annot=False, cmap="coolwarm", center=0)
	plt.title("Correlation Heatmap (numeric features)")
	plt.tight_layout()
	path = os.path.join(output_dir, "correlation_heatmap.png")
	plt.savefig(path, dpi=150)
	plt.close()
	return path


def plot_categorical_bars(df: pd.DataFrame, output_dir: str, max_plots: int) -> List[str]:
	paths: List[str] = []
	categorical_cols = df.select_dtypes(include=["object", "category"]).columns.tolist()
	if not categorical_cols:
		return paths

	# Choose columns with manageable cardinality
	cardinalities = {c: df[c].nunique(dropna=True) for c in categorical_cols}
	sorted_cols = [c for c, k in sorted(cardinalities.items(), key=lambda x: x[1]) if k <= 50]
	subset_cols = sorted_cols[:max_plots]
	if not subset_cols:
		return paths

	cols = 2
	rows = int(np.ceil(len(subset_cols) / cols))
	plt.figure(figsize=(cols * 6, rows * 4))
	for idx, column_name in enumerate(subset_cols, start=1):
		plt.subplot(rows, cols, idx)
		value_counts = df[column_name].value_counts(dropna=False).head(20)
		sns.barplot(x=value_counts.values, y=value_counts.index, orient="h")
		plt.title(f"Bar chart: {column_name} (top 20)")
	plt.tight_layout()
	path = os.path.join(output_dir, "categorical_bars.png")
	plt.savefig(path, dpi=150)
	plt.close()
	paths.append(path)
	return paths


def plot_scatter_pairs(df: pd.DataFrame, output_dir: str, max_pairs: int = 6) -> List[str]:
	paths: List[str] = []
	numeric_cols = df.select_dtypes(include=[np.number]).columns.tolist()
	if len(numeric_cols) < 2:
		return paths
	corr = df[numeric_cols].corr(numeric_only=True).abs()
	pairs: List[Tuple[str, str, float]] = []
	for i, col_i in enumerate(numeric_cols):
		for j in range(i + 1, len(numeric_cols)):
			col_j = numeric_cols[j]
			pairs.append((col_i, col_j, float(corr.loc[col_i, col_j])))
	pairs.sort(key=lambda x: x[2], reverse=True)
	top_pairs = pairs[:max_pairs]
	cols = 3
	rows = int(np.ceil(len(top_pairs) / cols))
	plt.figure(figsize=(cols * 5, rows * 4))
	for idx, (x_col, y_col, r) in enumerate(top_pairs, start=1):
		plt.subplot(rows, cols, idx)
		sns.scatterplot(x=df[x_col], y=df[y_col], s=10)
		plt.title(f"Scatter: {x_col} vs {y_col} (|r|={r:.2f})")
	plt.tight_layout()
	path = os.path.join(output_dir, "scatter_pairs.png")
	plt.savefig(path, dpi=150)
	plt.close()
	paths.append(path)
	return paths


def plot_timeseries(df: pd.DataFrame, datetime_columns: List[str], output_dir: str) -> List[str]:
	paths: List[str] = []
	if not datetime_columns:
		return paths

	primary_dt_col = datetime_columns[0]
	df_dt = df.copy()
	df_dt[primary_dt_col] = safe_to_datetime(df_dt[primary_dt_col])
	df_dt = df_dt.dropna(subset=[primary_dt_col])
	if df_dt.empty:
		return paths

	df_dt = df_dt.sort_values(by=primary_dt_col).set_index(primary_dt_col)
	count_series = df_dt.index.to_series().resample("D").size()
	plt.figure(figsize=(10, 4))
	count_series.plot()
	plt.title(f"Daily row count over time ({primary_dt_col})")
	plt.xlabel("Date")
	plt.ylabel("Count")
	plt.tight_layout()
	path = os.path.join(output_dir, "timeseries_counts.png")
	plt.savefig(path, dpi=150)
	plt.close()
	paths.append(path)

	numeric_cols = df_dt.select_dtypes(include=[np.number]).columns.tolist()
	for column_name in numeric_cols[:3]:
		plt.figure(figsize=(10, 4))
		series = df_dt[column_name].resample("D").mean()
		series.plot()
		plt.title(f"Daily mean of {column_name}")
		plt.xlabel("Date")
		plt.ylabel("Mean")
		plt.tight_layout()
		p = os.path.join(output_dir, f"timeseries_{column_name}.png")
		plt.savefig(p, dpi=150)
		plt.close()
		paths.append(p)
	return paths


def write_markdown_report(
	output_dir: str,
	csv_path: str,
	summary_text: str,
	missing_df: pd.DataFrame,
	outlier_df: pd.DataFrame,
	issues: dict,
	plot_paths: List[str],
	preview_rows: pd.DataFrame,
) -> str:
	report_path = os.path.join(output_dir, "report.md")
	with open(report_path, "w", encoding="utf-8") as f:
		f.write(f"# EDA Report\n\n")
		f.write(f"**Source file**: `{csv_path}`\n\n")
		f.write("## Quick summary\n\n")
		f.write(summary_text + "\n\n")

		f.write("## Missing values (top 20)\n\n")
		if not missing_df.empty:
			f.write(missing_df.head(20).to_markdown() + "\n\n")
		else:
			f.write("No missing values detected.\n\n")

		f.write("## Unusual values\n\n")
		f.write(f"- Duplicate rows: {issues.get('duplicate_rows', 0)}\n")
		f.write(f"- Constant columns: {issues.get('constant_columns', [])}\n")
		f.write(f"- Numeric columns with negative values: {issues.get('negative_value_columns', [])}\n")
		f.write(f"- Numeric columns that are all zeros: {issues.get('zero_only_columns', [])}\n\n")

		if not outlier_df.empty:
			f.write("### Numeric outliers (IQR method, top 20 by % outliers)\n\n")
			f.write(outlier_df.head(20).to_markdown(index=False) + "\n\n")

		f.write("## Plots\n\n")
		for p in plot_paths:
			filename = os.path.basename(p)
			f.write(f"- {filename}\n")

		f.write("\n## Data preview (first 10 rows)\n\n")
		f.write(preview_rows.head(10).to_markdown(index=False))
	return report_path


def main() -> None:
	args = parse_arguments()
	ensure_output_directory(args.output_dir)
	print(f"Loading CSV from: {args.path}")
	try:
		df = try_read_csv(args.path, delimiter=args.delimiter, encoding=args.encoding)
	except Exception as exc:
		print(f"Failed to read CSV: {exc}")
		sys.exit(1)

	# Detect potential datetime columns (best-effort)
	datetime_columns = detect_datetime_columns(df)
	if datetime_columns:
		print(f"Detected datetime-like columns: {datetime_columns}")

	# Summarize
	summary_text = summarize_dataframe(df)
	print("\n" + summary_text + "\n")

	# Missing values
	missing_df = compute_missing_values(df)
	missing_csv_path = os.path.join(args.output_dir, "missing_values.csv")
	missing_df.to_csv(missing_csv_path)

	# Unusual values and outliers
	outlier_df, issues = detect_unusual_values(df)
	outliers_csv_path = os.path.join(args.output_dir, "outliers_summary.csv")
	outlier_df.to_csv(outliers_csv_path, index=False)

	# Save a preview of the data
	save_dataframe_preview(df, args.output_dir)

	# Plots (optionally sample for speed)
	df_for_plots = maybe_sample(df, args.sample_rows)
	plot_paths: List[str] = []
	plot_paths += plot_numeric_distributions(df_for_plots, args.output_dir, args.max_plots)
	corr_path = plot_correlation_heatmap(df_for_plots, args.output_dir)
	if corr_path:
		plot_paths.append(corr_path)
	plot_paths += plot_categorical_bars(df_for_plots, args.output_dir, args.max_plots)
	plot_paths += plot_scatter_pairs(df_for_plots, args.output_dir)
	plot_paths += plot_timeseries(df_for_plots, datetime_columns, args.output_dir)

	# Markdown report
	report_path = write_markdown_report(
		output_dir=args.output_dir,
		csv_path=args.path,
		summary_text=summary_text,
		missing_df=missing_df,
		outlier_df=outlier_df,
		issues=issues,
		plot_paths=plot_paths,
		preview_rows=df,
	)

	print("\nArtifacts saved:")
	print(f"- Report: {report_path}")
	print(f"- Missing values: {missing_csv_path}")
	print(f"- Outliers summary: {outliers_csv_path}")
	for p in plot_paths:
		print(f"- Plot: {p}")


if __name__ == "__main__":
	main()