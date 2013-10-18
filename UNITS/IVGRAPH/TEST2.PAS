Uses IvGraph,IvWindow,IvKbd;


begin
 OpenWindow(1,1,20,20,DarkGrey,Blue,Double,'Test Window');
 repeat until KeyPresent;
 CloseWindow;
end.