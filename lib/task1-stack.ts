import * as cdk from '@aws-cdk/core';
import * as eks from '@aws-cdk/aws-eks';
const LAB_KEYPAIR_NM = 'lab-key-pair';
export class Task1Stack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const keyname = new cdk.CfnParameter(this, 'KeyName', {
      type: 'String',
      default: LAB_KEYPAIR_NM
  })

    // The code that defines your stack goes here
    const jamcluster = new eks.Cluster(this,'JamEksCluster',{
      version: eks.KubernetesVersion.V1_18,
      defaultCapacity: 1,
    }) 
    
    new cdk.CfnOutput(this, 'Key Name', { value: LAB_KEYPAIR_NM })
    new cdk.CfnOutput(this, 'eks-cluster-name', { value: jamcluster.clusterName })

  }
}
