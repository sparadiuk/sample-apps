#!/bin/sh
#
#  Copyright 2014-2016 CyberVision, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#


KAA_KEY_PATH="./cfg/key.txt"

if [[ -f "$KAA_KEY_PATH" ]]
then
    rm $KAA_KEY_PATH
fi

openssl genrsa -out key.pem 2048
openssl rsa -in key.pem -outform der -pubout > $KAA_KEY_PATH
rm key.pem