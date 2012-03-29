source("rErlang.R")

makeelist <- function(x) {
  res <- "["
  for (v in x) {
    if (res == "[") res <- paste(res, "\"")
    else res <- paste(res, ", \"")
    res <- paste(res, toString(v))
    res <- paste(res, "\"")
  }

  res <- paste(res, "]")
  
  return(res)
}

ecall <- function(left, bucket, key, param, right) {
  cl <- left
  cl <- paste(cl, "(<<\"")
  cl <- paste(cl, toString(bucket))
  cl <- paste(cl, "\">>, <<\"")
  cl <- paste(cl, toString(key))
  cl <- paste(cl, "\">>, ")
  cl <- paste(cl, param)
  cl <- paste(cl, ")")
  cl <- paste(cl, right)
  cl <- paste(cl, ".")

  return(eval(cl))
}

put <- function(bucket, key, val) {
  return(ecall("(element(2, riak:client_connect('riak@127.0.0.1'))):put(riak_object:new",
               bucket,
               key,
               makeelist(val),
               ", 1)"))
}

connect()
put("buck", "key", c(1, 2, 3, 4, 5))
