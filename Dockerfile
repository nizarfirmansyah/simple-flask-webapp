FROM python:3.9.0-slim-buster

LABEL maintainer=nizar.lazuardy@gmail.com

# Create appuser
RUN groupadd -g 999 appuser && \
    useradd --no-log-init -u 999 -g appuser appuser

# Copy source code, install libraries, & compile to bytecode
WORKDIR /app
ADD . /app
RUN pip3 install --no-cache-dir -r requirements.txt
RUN python3 -m compileall

# Changes ownership folder and switches to a non-root user
RUN chown -R appuser:appuser /app
USER appuser

# Run application
EXPOSE 5000
CMD [ "gunicorn", "main:app", "-w", "2", "--threads", "2", "-b", "0.0.0.0:5000", "--chdir", "__pycache__" ]