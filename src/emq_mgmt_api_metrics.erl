%%--------------------------------------------------------------------
%% Copyright (c) 2015-2017 EMQ Enterprise, Inc. (http://emqtt.io).
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emq_mgmt_api_metrics).

-author("Feng Lee <feng@emqtt.io>").

-rest_api(#{name   => list_metrics,
            method => 'GET',
            path   => "/metrics/",
            func   => list,
            descr  => "A list of metrics of all nodes in the cluster"}).

-rest_api(#{name   => list_node_metrics,
            method => 'GET',
            path   => "/nodes/:node/metrics/",
            func   => list,
            descr  => "A list of metrics of a node"}).

%% List metrics of all nodes
list(Bindings, _Params) when map_size(Bindings) == 0 ->
    {ok, emq_mgmt:metrics()};

%% List metrics of a node
list(#{node := Node}, _Params) ->
    case emq_mgmt:metrics(list_to_existing_atom(Node)) of
        {error, Reason} -> {error, Reason};
        Metrics -> {ok, Metrics}
    end.

