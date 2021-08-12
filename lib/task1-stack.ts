import * as cdk from '@aws-cdk/core';
import * as eks from '@aws-cdk/aws-eks';

export class Task1Stack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here
    const jamcluster = new eks.Cluster(this,'JamEksCluster',{
      version: eks.KubernetesVersion.V1_18,
      defaultCapacity: 1,
    })
  }
}
