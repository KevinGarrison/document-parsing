# ===========================
# Hybrid NLP Dockerfile using uv
# ===========================
FROM python:3.12-slim

# ---------------------------
# 1. Install system dependencies
# ---------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        unzip \
        wget \
        && rm -rf /var/lib/apt/lists/*

# ---------------------------
# 2. Install uv (Python package installer/build tool)
# ---------------------------
RUN python -m pip install --upgrade pip setuptools wheel
RUN python -m pip install --no-cache-dir uv

# ---------------------------
# 3. Install Python packages using uv
# ---------------------------
RUN uv add nltk
RUN uv add spacy
RUN uv add stanza

# ---------------------------
# 4. Download NLTK data (English + German)
# ---------------------------
RUN python3 -m nltk.downloader -d /usr/local/nltk_data \
        punkt \
        stopwords \
        wordnet \
        omw-1.4 \
        averaged_perceptron_tagger \
        maxent_ne_chunker \
        words \
        brown \
        reuters

ENV NLTK_DATA=/usr/local/nltk_data

# ---------------------------
# 5. Download SpaCy models
# ---------------------------
RUN python3 -m spacy download en_core_web_sm
RUN python3 -m spacy download de_core_news_sm

# ---------------------------
# 6. Download Stanza models (optional, German + English)
# ---------------------------
RUN python3 -c "import stanza; stanza.download('en')"
RUN python3 -c "import stanza; stanza.download('de')"

# ---------------------------
# 7. Set working directory
# ---------------------------
WORKDIR /app
COPY . /app

# ---------------------------
# 8. Default command
# ---------------------------
CMD ["uv", "run", "main.py"]