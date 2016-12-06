import logging
import os

# from whatever import *

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def handler(event, context):
    """Entry point for the Lambda function."""
    logger.info('Hello world')


if __name__ == '__main__':
    handler(None, None)
