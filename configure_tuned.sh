#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright Clairvoyant 2016

if ! rpm -q tuned; then exit 0; fi

if rpm -q redhat-lsb-core; then
  OSREL=`lsb_release -rs | awk -F. '{print $1}'`
else
  OSREL=`rpm -qf /etc/redhat-release --qf="%{VERSION}\n"`
fi
if [ "$OSREL" == 6 ]; then
  PROFILE=`tuned-adm active | awk '{print $NF}' | head -1`
  sed -e '/^vm.swappiness/s|= .*|= 1|' -i /etc/tune-profiles/${PROFILE}/sysctl.ktune
fi
if [ "$OSREL" == 7 ]; then
  PROFILE=`tuned-adm active | awk '{print $NF}'`
  mkdir /etc/tuned/${PROFILE}
  sed -e '/^vm.swappiness/s|= .*|= 1|' /usr/lib/tuned/${PROFILE}/tuned.conf >/etc/tuned/${PROFILE}/tuned.conf
fi
