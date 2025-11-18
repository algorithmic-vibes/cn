//congestion control using leaky bucket algorithm.
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define NOF_PACKETS 10

// Random function to generate packet sizes
int rand_val(int a) {
    int rn = (random() % 10) % a;
    return rn == 0 ? 1 : rn;
}

int main() {
    int packet_sz[NOF_PACKETS];
    int i, clk, b_size, o_rate, p_sz_rm = 0, p_sz, p_time, op;

    // Generate random packet sizes
    for (i = 0; i < NOF_PACKETS; i++)
        packet_sz[i] = rand_val(6) * 10;

    // Show generated packet sizes
    for (i = 0; i < NOF_PACKETS; i++)
        printf("\nPacket[%d]: %d bytes", i, packet_sz[i]);

    // Get output rate
    printf("\nEnter the Output rate: ");
    scanf("%d", &o_rate);

    // Get bucket size
    printf("Enter the Bucket Size: ");
    scanf("%d", &b_size);

    // Processing packets
    for (i = 0; i < NOF_PACKETS; i++) {

        // If incoming packet cannot fit
        if ((packet_sz[i] + p_sz_rm) > b_size) {

            if (packet_sz[i] > b_size) {
                // Packet itself larger than bucket
                printf("\nIncoming packet size (%d bytes) is greater than bucket capacity (%d bytes) - PACKET REJECTED",
                       packet_sz[i], b_size);
            } else {
                // Bucket overflow
                printf("\nBucket capacity exceeded - PACKETS REJECTED!!");
            }
        } else {
            p_sz_rm += packet_sz[i];
            printf("\nIncoming Packet size: %d", packet_sz[i]);
            printf("\nBytes remaining to Transmit: %d", p_sz_rm);

            p_time = rand_val(4) * 10;
            printf("\nTime left for transmission: %d units", p_time);

            // Simulate transmission in steps
            for (clk = 10; clk <= p_time; clk += 10) {
                sleep(1);

                if (p_sz_rm) {

                    if (p_sz_rm <= o_rate) {         // All remaining bytes transmitted
                        op = p_sz_rm;
                        p_sz_rm = 0;
                    } else {                        // Transmit fixed rate
                        op = o_rate;
                        p_sz_rm -= o_rate;
                    }

                    printf("\nPacket of size %d Transmitted", op);
                    printf("\nBytes Remaining to Transmit: %d", p_sz_rm);

                } else {
                    printf("\nTime left for transmission: %d units", p_time - clk);
                    printf("\nNo packets to transmit!!");
                }
            }
        }
    }

    return 0;
}
