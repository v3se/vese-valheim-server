import json
import os
import boto3
from botocore.exceptions import ClientError

from nacl.signing import VerifyKey
from nacl.exceptions import BadSignatureError

PUBLIC_KEY = os.environ['DISCORD_API_TOKEN'] # found on Discord Application -> General Information page

def lambda_handler(event, context):
  try:
    print(f"event {event}")
    body = json.loads(event['body'])
        
    signature = event['headers']['x-signature-ed25519']
    timestamp = event['headers']['x-signature-timestamp']

    # validate the interaction

    verify_key = VerifyKey(bytes.fromhex(PUBLIC_KEY))

    message = timestamp + json.dumps(body, separators=(',', ':'))
    
    try:
      verify_key.verify(message.encode(), signature=bytes.fromhex(signature))
    except BadSignatureError:
      return {
        'statusCode': 401,
        'body': json.dumps('invalid request signature')
      }
    
    # handle the interaction

    t = body['type']

    if t == 1:
      return {
        'statusCode': 200,
        'body': json.dumps({
          'type': 1
        })
      }
    elif t == 2:
      return command_handler(body)
    else:
      return {
        'statusCode': 400,
        'body': json.dumps('unhandled request type')
      }
  except:
    raise

def start_valheim_server():
    # Do a dryrun first to verify permissions
    ec2 = boto3.client('ec2', region_name='eu-north-1')
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:Name', 'Values':['valheim-server'],
            },
        ],
    )
    print(response)
    instance_id = response["Reservations"][0]["Instances"][0]["InstanceId"]

    try:
        ec2.start_instances(InstanceIds=[instance_id], DryRun=True)
    except ClientError as e:
        if 'DryRunOperation' not in str(e):
            raise
    # Dry run succeeded, run start_instances without dryrun
    try:
        response = ec2.start_instances(InstanceIds=[instance_id], DryRun=False)
        print(response)
        parse_id = response["StartingInstances"][0]["InstanceId"]

        response = ec2.describe_instances(
            Filters=[
                {
                    'Name': 'tag:Name', 'Values':['valheim-server'],
                },
            ],
        )

        ip_addr = response["Reservations"][0]["Instances"][0]["PublicIpAddress"]
        return {
        'statusCode': 200,
        'body': json.dumps({
            'type': 4,
            'data': {
            'content': "Starting instance with ID: " + parse_id  + "Public IP: " + ip_addr,
            }
        })
        }

    except ClientError as e:
        print(e)

def command_handler(body):
  command = body['data']['name']

  if command == 'bleb':
    return {
      'statusCode': 200,
      'body': json.dumps({
        'type': 4,
        'data': {
          'content': 'Hello, World.',
        }
      })
    }

  if command == 'start_valheim':
    return start_valheim_server()

  else:
    return {
      'statusCode': 400,
      'body': json.dumps('unhandled command')
    }