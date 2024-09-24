# Copyright 2024
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Use an official Python image as the base image
FROM python:3.8-slim

# Set a working directory inside the container
WORKDIR /docs

# Copy only the requirements file to avoid re-installing dependencies if code changes
COPY requirements.txt .

# Install dependencies using pip
# Here, we're installing MkDocs and the Material theme
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the documentation files into the working directory
COPY . .

# Expose port 8000 to access the MkDocs server from outside the container
EXPOSE 8000

# Command to run the MkDocs development server on port 8000
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
