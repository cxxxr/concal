(:mallet-config
 (:extends :default)

 ;; Line length limit
 (:enable :line-length :max 100)

 ;; Disable some info-level rules that may be too strict for this project
 (:disable :needless-let*))
