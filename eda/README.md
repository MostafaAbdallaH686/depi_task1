## Quick CSV EDA

This folder contains a simple script to generate a quick exploratory data analysis (EDA) for a CSV file. It summarizes the dataset, identifies missing/unusual values, and produces common visualizations. A Markdown report is saved alongside plots.

### Install dependencies

```bash
pip install -r /workspace/requirements.txt
```

### Run

```bash
python /workspace/eda/analyze_csv.py --path /absolute/path/to/your.csv --output-dir /workspace/eda_outputs
```

Optional arguments:
- `--max-plots` (default 12): limit the number of features visualized per plot group
- `--sample-rows` (default 0): randomly sample N rows for faster plotting on large files
- `--delimiter` (default ','): set the CSV delimiter
- `--encoding` (default auto): specify file encoding if auto-detection fails

Outputs will be saved to the specified output directory (default `/workspace/eda_outputs`).