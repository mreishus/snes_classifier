FROM frolvlad/alpine-miniconda3
# See git history for a continuumio/miniconda3 version
# slightly larger

# Install pytorch and fastai
RUN conda install --yes -c pytorch pytorch-cpu torchvision \
    && conda clean -tipsy \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete
RUN conda install --yes -c fastai fastai \
    && conda clean -tipsy \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete

# Install starlette and uvicorn
RUN conda install --yes -c conda-forge starlette uvicorn python-multipart aiohttp \
    && conda clean -tipsy \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete

ADD server.py server.py
ADD export.pkl export.pkl

# Run it once to trigger resnet download
#RUN python cities.py

EXPOSE 8000

# Start the server
CMD ["python", "server.py"]
