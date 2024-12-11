


# This file is a generated template, your changes will not be overwritten

omegaClass <- if (requireNamespace('jmvcore', quietly = TRUE))
  R6::R6Class("omegaClass",
              inherit = omegaBase,
              private = list(
                .run = function() {
                  # `self$data` contains the data
                  # `self$options` contains the options
                  # `self$results` contains the results object (to populate)
                  
                  items <- self$options$items
                  group <- self$options$group
                  
                  if(length(items) < 2 | is.null(group)) {
                    return()
                  }

                  self$results$text$setContent(paste(c("items:", items),
                                                     collapse = " ",
                                                     sep = " "))
                                    
                  result <-
                    multilevelTools::omegaSEM(items = items,
                                              id = group,
                                              data = self$data)$Results
                  
                  table <- self$results$omega
                  table$setRow(
                    rowNo = 1,
                    values = list(
                      label = stringr::str_replace_all(result[1, 'label'], "_", " "),
                      estimate = result[1,'est'],
                      ci.lower = result[1,'ci.lower'],
                      ci.upper = result[1,'ci.upper']
                    )
                  )
                  
                  table$setRow(
                    rowNo = 2,
                    values = list(
                      label = stringr::str_replace_all(result[2, 'label'], "_", " "),
                      estimate = result[2,'est'],
                      ci.lower = result[2,'ci.lower'],
                      ci.upper = result[2,'ci.upper']
                    )
                  )
                  
                }
              ))
