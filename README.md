# Container for the LTI Sample Tool Provider

This container runs the [LTI Sample Tool Provider (TP)](https://github.com/IMSGlobal/LTI-Sample-Tool-Provider-PHP) (released by the IMS Global Learning Consortium, Inc.) in a container.
See the [wiki of the tool provider](https://github.com/IMSGlobal/LTI-Sample-Tool-Provider-PHP/wiki/Usage) for instructions.
Minimal usage instructions are given below.

The built image from the Dockerfile is released in Docker Hub at <https://hub.docker.com/r/markkur/lti-sample-tool-provider-container/>.

## Brief instructions

You can start the TP and its database with the given *docker-compose.yml* file: run the command `docker-compose up`.
If you have a containerized learning management system (LMS), you could modify *docker-compose.yml* so that all containers are run at once.

Before an LMS may connect to the TP, you must enable the LMS in the admin view of the TP.
Go to <http://localhost:8070/admin> and create a new consumer. The key and secret defined here will be used in the LMS too.

When you configure the TP in the LMS, the launch URL of the LTI service is <http://localhost:8070/connect.php>.
The URL does not respond to normal GET requests without parameters. It expects a HTTP POST request with the LTI launch parameters.

