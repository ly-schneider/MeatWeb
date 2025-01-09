def lambda_handler(event, context):
    """
    Basic example Lambda handler that returns the event and some context attributes.
    """

    context_dict = {
        'function_name': context.function_name,
        'function_version': context.function_version,
        'invoked_function_arn': context.invoked_function_arn,
        'memory_limit_in_mb': context.memory_limit_in_mb,
        'aws_request_id': context.aws_request_id,
        'log_group_name': context.log_group_name,
        'log_stream_name': context.log_stream_name
    }

    return {
        'statusCode': 200,
        'body': {
            'event': event,
            'context': context_dict
        }
    }