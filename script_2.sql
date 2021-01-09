 with temp_data as
    (
     select TO_CHAR(2) as c1 , TO_CHAR(1) as c2 , TO_CHAR(3) as c3 from dual union all
     select TO_CHAR(3) as c1 , TO_CHAR(2) as c2 , TO_CHAR(1) as c3 from dual 
     union all 
     select 'Z' as c1 , 'X' as c2 , 'Y' as c3 from dual
     union all 
     select 'X' as c1 , 'Y' as c2 , 'Z' as c3 from dual 
     union all
     select 'Y' as c1 , 'Z' as c2 , 'X' as c3 from dual 
    ) 
   , calc_row as
    (
    select temp_data.* , row_number() over(order by null) row_no from temp_data where  c1 IN ('2','3')   
    ) 
   -- select * from calc_row;
   ,combined as
    (
        --combine column values into a single column.
        select ROW_NO, value from calc_row
            unpivot (value for cols in (c1,c2,c3) ) 
    )
   -- select * from combined;
    ,sorted as
        (
            --sort values in each row (grouped by rowID). This sorts the original data horizontally
            select ROW_NO, value, ROW_NUMBER() over (partition by ROW_NO order by value) as colID
            from combined
        ) 
    select * from sorted ;
    ,splitted as
(
    --split into columns again (based on that sorting)
    select * 
           --1 as c1, 2 as c2, 3 as c3
    from sorted
        pivot ( min(value) for colID in (1 as c1 ,2 as c2 ,3 as c3)) 
)    
   select * from splitted where rownum<=1 ;
