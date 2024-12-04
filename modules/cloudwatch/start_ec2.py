import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    instance_id = event['instance_id']
    region = event['region']
    
    # Start the EC2 instance
    ec2.start_instances(InstanceIds=[instance_id])
    
    return {
        'statusCode': 200,
        'body': f"Started EC2 instance {instance_id} in region {region}"
    }
}
