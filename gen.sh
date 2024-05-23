# Copyright © 2023 aetim. All rights reserved.
###
 # @Author: zhangkaiwei 1126763237@qq.com
 # @Date: 2024-05-11 23:00:19
 # @LastEditors: zhangkaiwei 1126763237@qq.com
 # @LastEditTime: 2024-05-11 23:04:44
 # @FilePath: \protocol\gen.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PROTO_NAMES=(
    "wrapperspb"
)

for name in "${PROTO_NAMES[@]}"; do
  protoc --go_out=plugins=grpc:./${name} --go_opt=module=github.com/Meikwei/protocol/${name} ${name}/${name}.proto
  if [ $? -ne 0 ]; then
      echo "error processing ${name}.proto"
      exit $?
  fi
done

if [ "$(uname -s)" == "Darwin" ]; then
    find . -type f -name '*.pb.go' -exec sed -i '' 's/,omitempty"`/\"\`/g' {} +
else
    find . -type f -name '*.pb.go' -exec sed -i 's/,omitempty"`/\"\`/g' {} +
fi