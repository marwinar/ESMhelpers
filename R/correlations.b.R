

# This file is a generated template, your changes will not be overwritten

correlationsClass <- if (requireNamespace('jmvcore', quietly = TRUE))
  R6::R6Class(
    "correlationsClass",
    inherit = correlationsBase,
    private = list(
      .init = function() {
        matrixbg <- self$results$matrixbg
        matrixwg <- self$results$matrixwg
        vars <- self$options$vars
        nVars <- length(vars)
        
        for (i in seq_along(vars)) {
          var <- vars[[i]]
          
          matrixbg$addColumn(
            name = paste0(var, '.bg'),
            title = var,
            type = 'number',
            format = 'zto',
            visible = TRUE
          )
          
          matrixwg$addColumn(
            name = paste0(var, '.wg'),
            title = var,
            type = 'number',
            format = 'zto',
            visible = TRUE
          )
        }
        
        for (i in seq_along(vars)) {
          var <- vars[[i]]
          valuesbg <- list()
          valueswg <- list()
          
          for (j in seq(i, nVars)) {
            v <- vars[[j]]
            valuesbg[[paste0(v, '.bg')]] <- ''
            valueswg[[paste0(v, '.wg')]] <- ''
          }
          
          valuesbg[[paste0(var, '.bg')]] <- '\u2014'
          valueswg[[paste0(var, '.wg')]] <- '\u2014'
          matrixbg$setRow(rowKey = var, valuesbg)
          matrixwg$setRow(rowKey = var, valueswg)
        }
        
        if (self$options$flag) {
          matrixbg$setNote('flag', '* p < .05, ** p < .01, *** p < .001')
          matrixwg$setNote('flag', '* p < .05, ** p < .01, *** p < .001')
        }
      },
      .run = function() {
        vars <- self$options$vars
        group <- self$options$group
        nVars <- length(vars)
        
        
        if (nVars < 2 | is.null(group)) {
          return()
        }
        
        my_data <- jmvcore::select(self$data, c(group, vars))
        result <- psych::statsBy(data = my_data, group = group)
        
        matrixbg <- self$results$matrixbg
        matrixwg <- self$results$matrixwg
        
        lapply(seq(2, nVars), function(i) {
          named_list <- as.list(setNames(result$rbg[i, ], colnames(result$rbg)))
          named_list <- purrr::discard(named_list, is.na)
          matrixbg$setRow(rowNo = i, head(named_list, i - 1))
        })

        lapply(seq(2, nVars), function(i) {
          named_list <- as.list(setNames(result$rwg[i, ], colnames(result$rwg)))
          named_list <- purrr::discard(named_list, is.na)
          matrixwg$setRow(rowNo = i, head(named_list, i - 1))
        })
        
        ## Flag p-values
        if (self$options$flag) {
          for (i in seq(2, nVars)) {
            for (j in seq(1, i - 1)) {
              if (result$pbg[i, j] < .001)
                matrixbg$addSymbol(rowNo=i, paste0(vars[j], ".bg"), '***')
              else if (result$pbg[i, j] < .01)
                matrixbg$addSymbol(rowNo=i, paste0(vars[j], ".bg"), '**')
              else if (result$pbg[i, j] < .05)
                matrixbg$addSymbol(rowNo=i, paste0(vars[j], ".bg"), '*')
            }
          }
          
          for (i in seq(2, nVars)) {
            for (j in seq(1, i - 1)) {
              pvalue <- result$pwg[i, j]
              if (is.nan(pvalue) | is.na(pvalue)) {
                # skip
              } else if (pvalue < .001)
                matrixwg$addSymbol(rowNo=i, paste0(vars[j], ".wg"), '***')
              else if (pvalue < .01)
                matrixwg$addSymbol(rowNo=i, paste0(vars[j], ".wg"), '**')
              else if (pvalue < .05)
                matrixwg$addSymbol(rowNo=i, paste0(vars[j], ".wg"), '*')
            }
          }
          
        }
                
      }
    )
  )
