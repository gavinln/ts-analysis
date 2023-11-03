"""
Download datasets for the notebooks

1. household power consumption data
2. air quality data

"""
import pathlib
from urllib.parse import urljoin
import urllib.request
import logging
import zipfile
import sys


SCRIPT_DIR = pathlib.Path(__file__).parent.resolve()
logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__file__)


def create_dir(path):
    "creates path dir if does not exist"
    if not path.exists():
        path.mkdir()
    return path.exists()


def download_url_to_file(url_base, download_dir, file_name):
    "downloads file from url_base to download_dir"
    url = urljoin(url_base, file_name)
    data_file = download_dir / file_name

    log.debug(f"Downloading {url}")
    urllib.request.urlretrieve(url, filename=data_file)


def download_data(download_dir, data_url, file_name, unzip_data):
    if not create_dir(download_dir):
        sys.exit(f"Cannot create dir {download_dir}")

    data_file = pathlib.Path(download_dir / file_name)
    if not data_file.exists():
        log.debug(f"Retriveing file {data_file}")
        download_url_to_file(data_url, download_dir, file_name)
    else:
        log.debug(f"File {data_file} already exists. Not downloading")

    if unzip_data:
        with zipfile.ZipFile(data_file, mode="r") as zipf:
            zipf.extractall(download_dir)


def main():
    download_dir = SCRIPT_DIR / ".." / ".." / "download_data_dir"

    data_url = "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/"
    file_name = "household_power_consumption.zip"
    download_data(download_dir, data_url, file_name, True)

    data_url = "https://raw.githubusercontent.com/marysia/pycon-time-series/main/data/"
    file_name = "air_quality.csv"
    download_data(download_dir, data_url, file_name, False)


if __name__ == "__main__":
    main()
