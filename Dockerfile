FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    JUPYTER_PORT=8888

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        ca-certificates \
        fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip \
    && pip install \
        jupyterlab \
        notebook \
        ipykernel \
        pandas \
        numpy \
        openpyxl \
        xlsxwriter \
        matplotlib \
        scipy

RUN useradd --create-home --shell /bin/bash jupyter \
    && mkdir -p /srv/jupyter/work \
    && chown -R jupyter:jupyter /srv/jupyter

USER jupyter
WORKDIR /srv/jupyter/work

EXPOSE 8888

CMD ["sh", "-c", "test -n \"$JUPYTER_TOKEN\" || { echo 'JUPYTER_TOKEN is required'; exit 1; }; exec jupyter lab --ip=0.0.0.0 --port=${JUPYTER_PORT:-8888} --no-browser --ServerApp.token=\"$JUPYTER_TOKEN\" --IdentityProvider.token=\"$JUPYTER_TOKEN\" --ServerApp.password='' --ServerApp.allow_origin='*' --ServerApp.allow_remote_access=True --ServerApp.root_dir=/srv/jupyter/work"]
