###Funcao para fazer count de numero de objetos dentro de um bucket  
###Count number of object using paginate 1000 objects 

def get_count_objects(bucket_name, bucket_conn, CEPH_BUCKET_MAX_KEYS):
    bucket = bucket_conn.lookup(bucket_name)
    objects     = bucket.get_all_keys(max_keys=CEPH_BUCKET_MAX_KEYS)
    objects_len = len(objects)
    n = objects_len
    print "Number objects:%s" %(n)
    while True:
        if objects_len < 1:
          #logger.warn("The Bucket:'%s' has no objects ", bucket.name)
          break 
        last_key_name = objects[-1].name
        #for key in objects:
            #yield key
        #    n += 1
        objects     = bucket.get_all_keys(max_keys=CEPH_BUCKET_MAX_KEYS, marker=last_key_name)
        objects_len = len(objects)
        n += objects_len
        print "Number objects:%s" %(n)
        if objects_len < 1:
            break
    return n 
    
Eg: get_all_objects('Catalog', bucket_src_conn, 1000)
