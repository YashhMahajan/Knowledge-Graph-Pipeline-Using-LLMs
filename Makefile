# Makefile for Knowledge Graph Pipeline
# =====================================

.PHONY: help install install-dev test lint format clean run-notebook docs

# Default target
help:
	@echo "Knowledge Graph Pipeline - Available Commands:"
	@echo ""
	@echo "  install      Install the package and dependencies"
	@echo "  install-dev  Install package with development dependencies"
	@echo "  test         Run the test suite"
	@echo "  lint         Run code linting"
	@echo "  format       Format code with black"
	@echo "  clean        Clean temporary files"
	@echo "  run-notebook Launch Jupyter notebook"
	@echo "  docs         Generate documentation"
	@echo ""

# Installation
install:
	pip install -e .

install-dev:
	pip install -e ".[dev,jupyter]"

# Testing
test:
	pytest tests/ -v --cov=. --cov-report=html --cov-report=term

test-fast:
	pytest tests/ -v -x

# Code Quality
lint:
	flake8 knowledge_graph_pipeline/ tests/
	mypy knowledge_graph_pipeline/

format:
	black knowledge_graph_pipeline/ tests/
	isort knowledge_graph_pipeline/ tests/

# Cleanup
clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf build/ dist/ .coverage htmlcov/ .pytest_cache/ .mypy_cache/

# Development
run-notebook:
	jupyter notebook main.ipynb

run-lab:
	jupyter lab main.ipynb

# Documentation
docs:
	@echo "Documentation available in README.md"

# Environment Setup
setup-env:
	cp .env.example .env
	@echo "Please edit .env file with your Groq API key"

# Quick Start
quick-start: install-dev setup-env
	@echo "Setup complete! Edit .env file and run 'make run-notebook'"

# Version management
version:
	@python -c "import knowledge_graph_pipeline; print(knowledge_graph_pipeline.__version__)"

# Distribution
build:
	python setup.py sdist bdist_wheel

upload-test:
	twine upload --repository testpypi dist/*

upload:
	twine upload dist/*
