// Leaky bucket — compact version
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#define NOF_PACKETS 10

/* random in 1..(a-1) (never returns 0) */
int r(int a){ int x = rand() % a; return x==0 ? 1 : x; }

int main(void){
    int pk[NOF_PACKETS], i, bucket = 0, o_rate, b_size;
    srand(time(NULL));

    for(i=0;i<NOF_PACKETS;i++) pk[i] = r(6) * 10;          // 10,20,30,40,50
    for(i=0;i<NOF_PACKETS;i++) printf("Packet[%d]=%d\n", i, pk[i]);

    printf("Output rate: "); scanf("%d",&o_rate);
    printf("Bucket size: "); scanf("%d",&b_size);

    for(i=0;i<NOF_PACKETS;i++){
        int p = pk[i];
        if(p > b_size) {
            printf("Packet %d (%dB) > bucket (%dB) — REJECTED\n", i, p, b_size);
            continue;
        }
        if(bucket + p > b_size) {
            printf("Bucket overflow on Packet %d — REJECTED\n", i);
            continue;
        }
        bucket += p;
        printf("\nPacket %d accepted (%dB). Buffered = %dB\n", i, p, bucket);

        int p_time = r(4) * 10;  // 10,20 or 30
        for(int clk=10; clk<=p_time; clk+=10){
            sleep(1);
            if(bucket == 0){
                printf("t=%d: no bytes to send\n", clk);
                continue;
            }
            int sent = (bucket <= o_rate) ? bucket : o_rate;
            bucket -= sent;
            printf("t=%d: sent %dB, remaining %dB\n", clk, sent, bucket);
        }
    }
    return 0;
}
