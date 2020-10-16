
-type(cluster() :: atom()).

-type(member_status() :: joining | up | healing | leaving | down).

-type(member_address() :: {inet:ip_address(), inet:port_number()}).

-record(member, {
          node   :: node(),
          addr   :: undefined | member_address(),
          guid   :: undefined | ekka_guid:guid(),
          hash   :: undefined | pos_integer(),
          status :: member_status(),
          mnesia :: running | stopped | false,
          ltime  :: erlang:timestamp()
         }).

-type(member() :: #member{}).

