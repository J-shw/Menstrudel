# Menstrudel Website Development

This guide explains how to set up the local development environment for the Menstrudel Jekyll website.

---
## 1. Prerequisites

Before you begin, make sure you have the following software installed on your computer.

* **Ruby:** Jekyll is built with Ruby. You can check if you have it by running `ruby -v`. If not, you'll need to install it.
* **Bundler:** A tool to manage Ruby project dependencies. If you don't have it, you can install it by running the following command in your terminal:
    ```bash
    gem install bundler
    ```
    

---
## 2. Environment Setup

This is a one-time setup to download all the necessary project files (called gems).

1.  **Clone the Repository (if you haven't already)**
    ```bash
    git clone <your-repository-url>
    ```

2.  **Navigate to the Website Directory**
    ```bash
    cd path/to/your/website
    ```

3.  **Install Dependencies**
    Run the following command to install Jekyll and all the plugins listed in the `Gemfile`.
    ```bash
    bundle install
    ```

---
## 3. Running the Local Server

Once the setup is complete, you can run the local test server.

1.  **Open a terminal** and make sure you are in the `/website` directory.

2.  **Run the Jekyll serve command:**
    ```bash
    bundle exec jekyll serve
    ```

This will build the website and start a local server, typically at **`http://127.0.0.1:4000`**. You can open this address in your web browser to see your changes live. The server will automatically rebuild the site whenever you save a file.