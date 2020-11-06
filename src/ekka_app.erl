%%--------------------------------------------------------------------
%% Copyright (c) 2019 EMQ Technologies Co., Ltd. All Rights Reserved.
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

-module(ekka_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
  stopped = mnesia:stop(),
  SN = ekka:env(sname),
  case node() of nonode@nohost when SN =/= undefined -> {ok,V} = SN, net_kernel:start([V, shortnames]);_ -> ok end,
  ok = mnesia:start(),
  ok = mnesia:wait_for_tables(mnesia:system_info(local_tables), 10000),
  {_, _R} = mnesia:change_table_copy_type(schema, node(), disc_copies),
  mnesia:create_schema([node()]),
  ekka_sup:start_link().

stop(_State) -> ok.

