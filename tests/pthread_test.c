#include <pthread.h>

int var = 0;

void* dowork(void *arg){
	(void)arg;
	var++;
	return 0;
}

int main(int argc, char **argv){
	(void)argc;
	(void)argv;
	
	int rc;
   pthread_t th1, th2;
   
   if ( (rc = pthread_create(&th1, 0, &dowork, 0)) != 0 )
		return rc;
   if ( (rc = pthread_create(&th2, 0, &dowork, 0)) != 0 )
		return rc;
   
   if ( (rc = pthread_join(th1, 0)) != 0 )
		return rc;
   if ( (rc = pthread_join(th2, 0)) != 0 )
		return rc;
	
	return var-2;
}
