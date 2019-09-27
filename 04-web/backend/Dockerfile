FROM continuumio/miniconda3

RUN apt-get update && apt-get install -y python3-dev gcc && apt-get autoclean && apt-get autoremove -y

# Install pytorch and fastai
RUN conda install --yes -c pytorch pytorch-cpu torchvision \
    && conda clean -afy \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete
RUN conda install --yes -c fastai fastai \
    && conda clean -afy \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete

# Install starlette and uvicorn
RUN pip install starlette uvicorn python-multipart aiohttp

RUN apt-get --purge autoremove -y python3-dev gcc

ADD server.py server.py
ADD export.pkl export.pkl

# Run it once to trigger resnet download
#RUN python cities.py

EXPOSE 8000

# Start the server
CMD ["python", "server.py"]
