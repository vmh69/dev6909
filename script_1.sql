  with msg_temp as
    (
    select 1 as id , systimestamp as creation_date , 'Msg#1' msg_Content ,0 as SendState , 0 as AckState from dual union all
    select 2 as id , systimestamp as creation_date , 'Msg#2' msg_Content ,0 as SendState , 0 as AckState from dual  union all
    select 3 as id , systimestamp as creation_date , 'Msg#3' msg_Content ,1 as SendState , 1 as AckState from dual  union all
    select 4 as id , systimestamp as creation_date , 'Msg#4' msg_Content ,1 as SendState , 1 as AckState from dual  union all
    select 5 as id , systimestamp as creation_date , 'Msg#5' msg_Content ,1 as SendState , 1 as AckState from dual  union all
    select 6 as id , systimestamp as creation_date , 'Msg#6' msg_Content ,1 as SendState , 0 as AckState from dual  union all
    select 7 as id , systimestamp as creation_date , 'Msg#7' msg_Content ,1 as SendState , 0 as AckState from dual  
    ),
     Result
            as
            (
                Select
                (Select NVL(Max(C.id)+1, (Select Min(id) from msg_temp)) from msg_temp C
                        where
                            C.id <= A.id and
                            (C.SendState<>A.SendState or C.AckState<>A.AckState)
                        ) as MinID
                ,
                (Select NVL(Min(C.id)-1, (Select Max(id) from msg_temp)) from msg_temp C
                        where
                            C.id >= A.id and
                            (C.SendState<>A.SendState or C.AckState<>A.AckState)
                        ) as MaxID
                ,A.SendState, A.AckState
                From msg_temp A
                group by A.SendState, A.AckState
            )
             
            Select distinct C.MinID, C.MaxID, C.SendState, C.AckState
            from Result C
            order by C.MinID;
   
                
       
       
       WITH min_id 
     AS (SELECT Min(id) min_value, 
                Max(id) max_value 
         FROM   msg_temp), 
     result 
     AS (SELECT (SELECT Nvl(Max(C.id) + 1, min_value) 
                 FROM   msg_temp C 
                 WHERE  C.id <= A.id 
                        AND ( C.sendstate <> A.sendstate 
                               OR C.ackstate <> A.ackstate )) MinID, 
                (SELECT Nvl(Min(C.id) - 1, max_value) 
                 FROM   msg_temp C 
                 WHERE  C.id >= A.id 
                        AND ( C.sendstate <> A.sendstate 
                               OR C.ackstate <> A.ackstate )) AS MaxID, 
                A.sendstate, 
                A.ackstate 
         FROM   msg_temp A, 
                min_id) 
		SELECT DISTINCT C.minid, 
						C.maxid, 
						C.sendstate, 
						C.ackstate 
		FROM   result C 
		ORDER  BY C.minid; 

select * from msg_temp;