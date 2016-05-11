###s3_diff_objects
###Function using Api S3 amanzon to count all objects on two Buckets Source and Destination 
###and Print List of Diff objects from Source to Destination Sync 
def sync_stats(source_bucket, destination_bucket, objects):
    CEPH_BUCKET_MAX_KEYS = objects
    ceph_src_conn = get_src_bucket_connection(bucket=source_bucket)
    ceph_dst_conn = get_dst_bucket_connection(bucket=destination_bucket)

    bucket_src = ceph_src_conn.lookup(source_bucket)
    bucket_dst = ceph_dst_conn.lookup(destination_bucket)
    objects_src     = bucket_src.get_all_keys(max_keys=CEPH_BUCKET_MAX_KEYS)
    objects_dst     = bucket_dst.get_all_keys(max_keys=CEPH_BUCKET_MAX_KEYS)
    objects_src_len = len(objects_src)
    objects_dst_len = len(objects_dst)
    n_src = objects_src_len
    n_dst = objects_dst_len
    lista_obj = []
    while True:
        if objects_src_len < 1: 
            break 
        else:
            last_key_name_src = objects_src[-1].name
        if objects_dst_len >= 1:
            last_key_name_dst = objects_dst[-1].name
        #else:    
        #    last_key_name_dst = objects_dst[-1].name
        for key in objects_src: 
            if not bucket_dst.get_key(key.name):
                lista_obj.append(key.name)
                        
        objects_src    = bucket_src.get_all_keys(max_keys=CEPH_BUCKET_MAX_KEYS, marker=last_key_name_src)
        objects_dst    = bucket_dst.get_all_keys(max_keys=CEPH_BUCKET_MAX_KEYS, marker=last_key_name_dst)
        objects_src_len = len(objects_src)
        objects_dst_len = len(objects_dst)
        n_src += objects_src_len
        n_dst += objects_dst_len
        #print "Number objects:%s" %(n)
        if objects_src_len < 1 and objects_src_len < 1:
            break
    #print("Object Source Has:'%s' objects ", n_src)
    #print("Object Destination Has:'%s' objects ", n_dst)
    if n_src <= n_dst:
        print("Object Source Has:'%s' objects " % n_src)
        print("Object Destination Has:'%s' objects " % n_dst )
        print("Destion Has :'%s' More Objects and Source " % (n_dst - n_src) )
        print('Sync from Source To Destination OK ')
        print('--------------List from Diff objects :--------------')
        for obj in lista_obj:
            print obj

    if n_src > n_dst:
        print("Object Source Has:'%s' objects " % n_src)
        print("Object Destination Has:'%s' objects " % n_dst )
        print("Destion Has :'%s' More Objects and Source " % ( n_src - n_dst ) )
        print('--------------List from Diff objects :--------------')
        for obj in lista_obj:
            print obj
    
           
