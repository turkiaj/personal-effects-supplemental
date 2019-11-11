
# Accuracy evaluation for different model candidates

mebn_rep_accuracy <- function(model_name, model_dir, amount_of_subjects, assumedtargets) {
  
  eval.mat <- matrix(0, nrow=nrow(assumedtargets),ncol=4)
  
  allrep <- get_rep_response_for_all(model_dir)
  
  number_of_preds <- 0
  
  for (subject_number in 1:amount_of_subjects)
  {
    number_of_preds <- number_of_preds + 1
    
    # result contains all (4) personal responses in order by week
    rep_response <- get_rep_response(allrep, subject_number)
    true_response <- get_true_response(subject_number)
    
    # delta contains differences of successive responses
    rep_delta <- make_delta(rep_response)
    true_delta <- make_delta(true_response)
    
    # we only evaluate now if the predicted sign of the change matches true sign of the change
    sign_matrix <- sign(rep_delta) == sign(true_delta)
    
    # average accuracy of all matches in all weeks
    avg_change <- sign(rowSums(true_response[,2:4])/3 - true_response[,1]) == sign(rowSums(rep_response[,2:4])/3 - rep_response[,1])
    eval.mat <- eval.mat + cbind(sign_matrix[,2:4]*1, avg_change*1)
  }
  
  eval.mat <- eval.mat/number_of_preds * 100
  eval.mat <- cbind(eval.mat, rowMeans(eval.mat[,1:3]))
  eval.mat <- round(eval.mat,0)
  eval.mat <- cbind(c(model_name), eval.mat)
  
  return(eval.mat)
}



# Helper fuctions for model evaluation
library(dplyr)
library(tidyr)

true_values <- sysdimet[c("SUBJECT_ID", "WEEK", as.vector(assumedtargets$Name))]

get_true_response <- function(holdout_number) {
  
  #holdout_subject <- sprintf("S%02d", holdout_number)
  holdout_subject <- levels(sysdimet$SUBJECT_ID)[holdout_number]
  
  true_response <- true_values %>%
    filter(SUBJECT_ID == holdout_subject) %>%
    select(as.vector(assumedtargets$Name)) %>%
    t %>%
    as.matrix
  
  colnames(true_response) <- c(0,4,8,12)
  return(true_response)
}

get_pred_response <- function(localfit_directory) {
  
  pred_response <- NULL
  
  for (targetname in assumedtargets$Name)
  {
    print(targetname)
    target_blmm <- mebn.get_localfit(paste0(localfit_directory,targetname))
    
    if (!is.null(target_blmm))
    {
      ms <- rstan::summary(target_blmm, pars=c("Y_pred"), probs=c(0.10, 0.90), na.rm = TRUE)
      
      if (is.null(pred_response))
        pred_response <- as.vector(ms$summary[1:4,c(1)])
      else
        pred_response <- rbind(pred_response, as.vector(ms$summary[1:4,c(1)]))
    }
    else
    {
      print(paste0("Local model ", paste0(localfit_directory,targetname), " is missing."))
    }
  }
  
  colnames(pred_response) <- c(0,4,8,12)
  rownames(pred_response) <- as.vector(assumedtargets$Name)
  
  return(pred_response)
}

get_rep_response_for_all <- function(localfit_directory) {
  
  rep_response <- NULL
  
  for (targetname in assumedtargets$Name)
  {
    target_blmm <- mebn.get_localfit(targetname, localfit_directory)
    ms <- rstan::summary(target_blmm, pars=c("Y_rep"), probs=c(0.10, 0.90), na.rm = TRUE)
    
    if (is.null(rep_response))
      rep_response <- as.vector(ms$summary[,c(1)])
    else
      rep_response <- rbind(rep_response, as.vector(ms$summary[,c(1)]))
  }
  
  rownames(rep_response) <- as.vector(assumedtargets$Name)
  
  return(rep_response)
}

get_rep_response_for_expfam <- function(target_models_dirs) {
  
  rep_response <- NULL
  
  for (targetname in assumedtargets$Name)
  {
    localfit_directory <- target_models_dirs[target_models_dirs$Name==targetname,]$modelcache
    
    target_blmm <- mebn.get_localfit(targetname, localfit_directory)
    
    ms <- rstan::summary(target_blmm, pars=c("Y_rep"), probs=c(0.10, 0.90), na.rm = TRUE)
    
    if (is.null(rep_response))
      rep_response <- as.vector(ms$summary[,c(1)])
    else
      rep_response <- rbind(rep_response, as.vector(ms$summary[,c(1)]))
  }
  
  rownames(rep_response) <- as.vector(assumedtargets$Name)
  
  return(rep_response)
}

get_rep_response <- function(rep_matrix, subject_number) {
  
  s <- (subject_number-1)*4 + 1
  e <- s + 3
  
  return(rep_matrix[,s:e])
}  

make_delta <- function(true_response)
{
  true_delta <- true_response
  true_delta[,4] <- true_delta[,4] - true_delta[,3]
  true_delta[,3] <- true_delta[,3] - true_delta[,2]
  true_delta[,2] <- true_delta[,2] - true_delta[,1]
  true_delta[,1] <- 0
  
  return(true_delta)
}


