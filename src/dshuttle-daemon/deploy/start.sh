#!/bin/bash

# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

pushd $(dirname "$0") > /dev/null

kubectl apply --overwrite=true -f dshuttle-worker.yaml || exit $?
kubectl apply --overwrite=true -f dshuttle-csi-driver.yaml || exit $?
kubectl apply --overwrite=true -f dshuttle-csi-daemon.yaml || exit $?

sleep 10
# Wait until the service is ready.
PYTHONPATH="../../../deployment" python -m k8sPaiLibrary.monitorTool.check_pod_ready_status -w -k app -v dshuttle-worker || exit $?
PYTHONPATH="../../../deployment" python -m k8sPaiLibrary.monitorTool.check_pod_ready_status -w -k app -v dshuttle-csi-daemon || exit $?

popd > /dev/null
