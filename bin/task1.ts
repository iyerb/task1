#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { Task1Stack } from '../lib/task1-stack';

const app = new cdk.App();
new Task1Stack(app, 'Task1Stack', {});
