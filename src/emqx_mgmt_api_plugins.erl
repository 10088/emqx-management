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

-module(emqx_mgmt_api_plugins).

-author("Feng Lee <feng@emqtt.io>").

-include_lib("emqx/include/emqx.hrl").

-rest_api(#{name   => list_all_plugins,
            method => 'GET',
            path   => "/plugins/",
            func   => list,
            descr  => "List all plugins in the cluster"}).

-rest_api(#{name   => list_node_plugins,
            method => 'GET',
            path   => "/nodes/:atom:node/plugins/",
            func   => list,
            descr  => "List all plugins on a node"}).

-rest_api(#{name   => load_plugin,
            method => 'PUT',
            path   => "/nodes/:atom:node/plugins/:atom:plugin/load",
            func   => load,
            descr  => "Load a plugin"}).

-rest_api(#{name   => unload_plugin,
            method => 'PUT',
            path   => "/nodes/:atom:node/plugins/:atom:plugin/unload",
            func   => unload,
            descr  => "Unload a plugin"}).

-export([list/2, load/2, unload/2]).

list(#{node := Node}, _Params) ->
    {ok, format(emqx_mgmt:list_plugins(Node))};

list(_Bindings, _Params) ->
    {ok, format(emqx_mgmt:list_plugins())}.

load(#{node := Node, plugin := Plugin}, _Params) ->
    return(emqx_mgmt:load_plugin(Node, Plugin)).

unload(#{node := Node, plugin := Plugin}, _Params) ->
    return(emqx_mgmt:unload_plugin(Node, Plugin)).

format(#mqtt_plugin{name = Name, version = Ver, descr = Descr, active = Active}) ->
    [{name, Name}, {version, iolist_to_binary(Ver)}, {description, iolist_to_binary(Descr)}, {active, Active}];

format(Plugins) when is_list(Plugins) ->
    [format(Plugin) || Plugin <- Plugins].

return(ok) ->
    ok;
return({ok, _}) ->
    ok;
return({error, Reason}) ->
    {error, #{message => Reason}}.

