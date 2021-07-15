# Time series analysis

* Source code - [Github][1]
* Author - Gavin Noronha

[1]: https://github.com/gavinln/ts-analysis.git

## About

This project has examples of time series analysis using Python

## Setup the project

1. Start the Windows subsystem for Linux

### 1.1 Setup the project using a Pipfile

1. Create an environment and install libraries

```
pipenv install --python $(which python3)
```

### 1.2 Setup the environment manually

1. To create a Pipfile on the Windows subsystem for Linux and choose the
   correct Python

```
pipenv --python $(which python3)
```

2. Setup the libraries manually

```
pipenv install jupyterlab
pipenv install flake8
pipenv install mypy
pipenv install yapf
pipenv install seaborn
# pipenv install jupyterlab-git
# pipenv install jupyterlab-lsp
```

### Setup the tmux environment

```
make tmux
```

## Jupyter plugins

### Jupyter lab

1. List Jupyterlab extensions

```
jupyter labextension list
```

4. Install the [Jupyter language server](https://github.com/krassowski/jupyterlab-lsp)

5. Start the Jupyter lab interface

```
make jupyter-lab
```

5. Evaluate these Jupyter lab extensions

* jupyterlab-execute-time (evaluate)
* @jupyterlab/git (needs: pip install jupyterlab-git)

## Links

### Forecasting time series

[Facebook Prophet library][1000]

[1000]: https://github.com/facebook/prophet

### Fourier series

* Introduction to [Fourier Transforms with Python][1010]

[1010]: https://realpython.com/python-scipy-fft/

* Fourier analysis [39 video lecture series][1020]

[1020]: https://www.youtube.com/playlist?list=PLMrJAkhIeNNT_Xh3Oy0Y4LTj0Oxo8GqsC

### Time series analysis books

* A list of [7 books on Time Series Analysis][1030]

[1030]: https://www.tableau.com/learn/articles/time-series-analysis-books

### Course on the analysis of time series

* [Course page][1040]

* [Github code][1050]

[1040]: https://ionides.github.io/531w21/
[1050]: https://github.com/ionides/531w21/

### Time series analysis example

* Example of using the [Household Electricity Usage][1060] dataset

[1060]: https://machinelearningmastery.com/how-to-load-and-explore-household-electricity-usage-data/

* Example of using the [Air quality][1070] dataset

[1070]: https://github.com/marysia/pycon-time-series

### Videos

[Time Series Analysis - PyCon 2017][1100]

[1100]: https://www.youtube.com/watch?v=zmfe2RaX-14

time: 2:23:00

```
09a. AR + MA process
09b. Forecasting
10. Clustering and Classification
```

[Modern Time Series Analysis - SciPy 2019][1120]

[1120]: https://www.youtube.com/watch?v=v5ijNXvlC5A

[Python time series analysis][1130] - PyCon 2021

[1130]: https://www.youtube.com/watch?v=nT6UsVgJ0xw

[Anomaly detection][1140]

[1140]: https://www.youtube.com/watch?v=1NXryMoU7Ho
