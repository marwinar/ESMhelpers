

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
                  
                  result <- 
                    multilevelTools::omegaSEM(
                      items = items,
                      id = group,
                      data = self$data
                    )
                  
                  self$results$text$setContent(result)
                  
                }
              ))
