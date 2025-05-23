# docs
This Repo contains docs for the pyworldwide team.

## Local Dev setup

To set up a local dev environment for the docs, follow these steps:

### Requirements

Have these installed first before continuing further.

- GNU Make (https://www.gnu.org/software/make/)
- cURL (https://curl.se/)

1. Fork the [docs](https://github.com/pyworldwide/docs) repository to your GitHub account and get the source code using:

```bash
git clone https://github.com/<your_username>/docs.git
```

2. Change directory to the cloned repo

```bash
cd docs
```

3. To serve the docs locally, run the following command (this will start a local server and install the requirements):

```bash
make serve
```

4. To build the docs, run the following command:

```bash
make build
```

5. To clean the build artifacts, run the following command:

```bash
make build-clean
```

6. To clear the cache, run the following command:

```bash
make cache-clear
```

7. To build requirements, run the following command:

```bash
make requirements
```