import * as cdk from '@aws-cdk/core';
import * as eks from '@aws-cdk/aws-eks';
import * as ec2 from '@aws-cdk/aws-ec2';
import * as iam from '@aws-cdk/aws-iam';
import { MyChart } from './my-chart';
import * as cdk8s from 'cdk8s'

const LAB_KEYPAIR_NM = 'lab-key-pair';
export class Task1Stack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const keyname = new cdk.CfnParameter(this, 'KeyName', {
      type: 'String',
      default: LAB_KEYPAIR_NM
  })

    /**
       * Create a new VPC with single NAT Gateway
       */
    const vpc = new ec2.Vpc(this, 'EksClusterVPC', {
      cidr: '10.0.0.0/16',
      natGateways: 1
    });

    const clusterAdmin = new iam.Role(this, 'AdminRole', {
      assumedBy: new iam.AccountRootPrincipal()
    });


    // The code that defines your stack goes here
    const jamcluster = new eks.Cluster(this,'JamEksCluster',{
      version: eks.KubernetesVersion.V1_18,
      vpc: vpc,
      defaultCapacity: 1,
      mastersRole: clusterAdmin,
      outputClusterName: true
    }) 

    /**
     * Code to add pods on eks cluster. All containers are defined in MyChart
     */
    //jamcluster.addCdk8sChart('my-chart', new MyChart(new cdk8s.App(), 'MyChart'));
    
    new cdk.CfnOutput(this, 'Key Name', { value: LAB_KEYPAIR_NM })
    new cdk.CfnOutput(this, 'eks-cluster-name', { value: jamcluster.clusterName })

  }
}
