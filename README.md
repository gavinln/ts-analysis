# Time series analysis

* Source code - [Github][1]
* Author - Gavin Noronha

[1]: 

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

https://github.com/facebook/prophet

### Fourier series

https://realpython.com/python-scipy-fft/

https://www.youtube.com/playlist?list=PLMrJAkhIeNNT_Xh3Oy0Y4LTj0Oxo8GqsC

### Time series analysis books

https://www.tableau.com/learn/articles/time-series-analysis-books

### Videos

[Time Series Analysis - PyCon 2017][1100]

[1100]: https://www.youtube.com/watch?v=zmfe2RaX-14

[Modern Time Series Analysis - SciPy 2019][1120]

[1120]: https://www.youtube.com/watch?v=v5ijNXvlC5A

