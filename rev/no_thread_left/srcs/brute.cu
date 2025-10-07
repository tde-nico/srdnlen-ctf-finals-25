#include <iostream>
#include <cuda.h>
#include <curand_kernel.h>
#include <map>



// https://docs.nvidia.com/cuda/cuda-runtime-api/group__CUDART__TYPES.html
#define CHECK(val) check_cuda( (val), #val, __FILE__, __LINE__ )
void check_cuda(cudaError_t res, const char *func, const char *file, const int line)
{
	if (!res)
		return ;
	std::cerr << "CUDA error = " << static_cast<unsigned int>(res);
	std::cerr << " at " << file << ":" << line << " '" << func << "' \n";
	cudaDeviceReset();
	exit(1);
}

typedef unsigned long long ll;

__device__ unsigned char constant_bits[] = {
	0x01, 0x00, 0x01, 0x01, 0x00, 0x01, 0x00, 0x00, 0x01, 0x00, 
	0x01, 0x01, 0x01, 0x00, 0x00, 0x01, 0x01, 0x00, 0x01, 0x01, 
	0x00, 0x00, 0x01, 0x00, 0x00, 0x01, 0x01, 0x00, 0x01, 0x00, 
	0x01, 0x00, 0x01, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x01, 
	0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x01, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00
};


#define STEP(x) ((((x ^ (x >> 12)) << 25) ^ x ^ (x >> 12)) >> 27) ^ ((x ^ (x >> 12)) << 25) ^ x ^ (x >> 12)


// time:    0000000068d57f89
// pid:     00000000000f8c43
// address: 00007f95168f46c0
// seed:    00007f957e55b50a
// 0dbdb1da008ce6a4e8b46f0f83aa8752b3862504f0b5dc69a0d441baa306e04e3caee5e572b041fab2db55f9b521372cbd4088ad346a97815906164b77b70003f078b0e51f4b44234efcb468a464e561f88182f00ad172650dab317d4279a2f6ecea1135a62a85b1a4293783cb3a28df36a992b0111060f858d50912d0bc504db44f38535511e319ac1249d1b76156a60246462a959f5aed9d26a186c207be21808ccf2bd7363993922022b110a31f45c86fbc00914b6c5dbd98504c7be7f94e53b158a7aabe322b95695775b82b17f933928bf2cfded7d869698c6cf274b0c2f9c58feff0e8fb2b3ba82e845d8e82149b37a7f3ce7791ec0e165d1e8b853e4224a4fbd1a58127961bbf0c2eddf73fe99674549e61ec05ba1fe8fdaf3e631e6daaddc75a96eccbe14fe2f12a1c056082b8aada2fcf08a4be57f88606e981b11d5a5a56d3926ad6092a5aa804eb342fbeee3d60b1e61e8824e7eed9b8fc8a44188f30ab50de839e20890d0ca86a72ab18a2022e698a2a99d7b9e31bc0c6c7e3384ceea4e43895d923babbfa9ae7a4ba65eb94203927bf1b000f10fbe11621726cb132c1f54ff4892bc4e42659ca7d6a9d97d4a2d1e098b72a8e86058095776ffa2ba811e7886ad403d7bd08bd5ed2fdccab716f0cb685463b6f6f6bb8c467a620863c93b817c4cf28ef431d57350fb95b23fcf05171f5b2d79788ee247e21cb33d50a6f4d67dda8eb05b566e7c14cfd5ee52a5e37a67c4bd9a698cd9e9c2adc10a9c3b89090337f7c3702e2c7d5c01873944853eb833a7aafbc42c48481c7d6d044b1085993f78d04dc8715c28cfe818cab5d01bac5c9258155c257fa025558add2301e77e019d43d4469c977f038daff0ebacffa54001e32f2954a2e019abf440036b1fc9e8a8c3b1ba4e97042dd2d953f38a7e104adbea73a7b08584d912298af5cf8de66a8420b27c87b4ecd434c0271f63703bb91b234d001052c8c55ccaddbcdf9444771fb30b0a9c6fe1d290cb3727399d33816f426ac3b37be50942cef57c679142f3f3f055d3efd52d966ee

// d4a3731ae72140a58b39a2e3356a5971b489402ec60f70e1b6f53241a20c225c500f8960fa79def2505c09422d93a658c193fbb660f86e17d3d26e69f6e21e19086b4eacdd6b9bffe06c83c7cda32e255c145df02b31f04ff754dcbfae54da15d079a69ecda1df646660a8ca773745630afc804f72dcbcd60374e45f44ba288681ce34705c9d111eb5d714225463e41602d3c3e4bd4fd1f78e8458748a5f048b40cde6190a163c1e487467b8281a3f96709241cf0486a6bc0a4c39c6cafef2bd388c0df908f1e86f4699c584aa39c86f94111ec5eb9dea30e7c6e89aa477e9b82efb49f089715653aa146e06a4440249256d24b638190a02541c81c183934f30441a72b190992593ccbbd69785afe23d149cf7c5279bc32b878a9f66c005439e6baefca86bfc5c06a5db7e0f916ca1de9dd6a94c6f5c6cd3c92f1dc29708197c3a7567a5c3c5f9e1f43460098e898734cd21c392687b8faf80da32fe66f3467d9cb28c09dacade1e0515e7587d6ed60101ce6e78cbf9d505b6ff0b63b1b7a1875cfc0df606d10e85de74dbb6804099678c05505f3625db279645ab0a03458750c051654dbb6eba6d30a8d4860fe52366e585069d8eb59e185819415996371d4da2be287b8cd89d7e3f09ca14b6e4601d9e8db0a3af584d9e4c0c59595447225a39b5196534825965d8837380ae9d5457ced63cd1597baf1f7104e345d63900ed6ce8
__constant__ const unsigned char CMP[] = {30, 12, 97, 46, 147, 112, 175, 112, 239, 211, 139, 56, 216, 199, 13, 24, 90, 186, 254, 215, 205, 212, 84, 143, 214, 217, 132, 149, 171, 47, 159, 214, 0, 14, 181, 211, 206, 133, 74, 141, 27, 111, 128, 220, 10, 163, 123, 20, 55, 162, 193, 190, 131, 134, 204, 233, 205, 172, 188, 8, 52, 217, 37, 243, 140, 103, 214, 184, 67, 142, 58, 168, 141, 158, 173, 202, 251, 208, 19, 105, 131, 29, 219, 155, 234, 149, 220, 38, 115, 42, 251, 151, 241, 9, 129, 183, 141, 146, 161, 105, 93, 129, 138, 82, 20, 31, 190, 127, 108, 209};

__global__	void brute() {
	// int control_bit = constant_bits[0];
	// ll state = threadIdx.x + blockIdx.x * (blockIdx.y + gridDim.x * (blockDim.y + gridDim.y * blockDim.z));

	// ll time = 0x000000068d582d1;
	ll time = 1758828330;
	// ll pid = 0x0000000000f9e85 - 4000 + blockIdx.z;
	ll pid = blockIdx.z;
	// ll addr = 0x00007fe27f9216c0;
	//        0x00007fe27f9216c0
	ll addr = 0x00007000000006c0 + ((ll)(threadIdx.x + blockDim.x * (threadIdx.y + blockDim.y * (blockIdx.x + gridDim.x * blockIdx.y))) << 12);
	ll state = ((time << 32) ^ pid) ^ addr;
	// printf("Initial state: %llx\n", state);
	// printf("Trying! Time: %llx\n", (threadIdx.x + blockDim.x * (threadIdx.y + blockDim.y * (blockIdx.x + gridDim.x * blockIdx.y))));
	//         0x00007fe27f9216c0
	// if (addr > 0x000070e0000006c0)
	// 	printf("Trying! Addr: %llx\n", addr);

	ll v10 = STEP(state);
	ll v13 = STEP(v10);
	ll byte = STEP(v13);
	ll v17 = 0x4F6CDD1D * (int)byte % 0x201u + 384;

	if (v17 != 857)
		return ;

	ll idx = 0;
	unsigned char buf[0x201u+384];
	do {
		byte ^= STEP(byte) ^ byte;
		buf[idx++] = 0x1D * byte;
	} while (v17 > (int)idx);
	
	// for (int i = 0; i < v17; i++) {
	// 	printf("%02x", buf[i]);
	// }
	// printf("\n");

	ll i = 0;
	ll *s1 = (ll *)buf, *s2 = (ll *)CMP;
	while (i < 4) {
		if (s1[i] != s2[i])
			return ;
		++i;
	}

	printf("Found! Time: %llx\n", time);
	printf("Found! Pid: %llx\n", pid);
	printf("Found! Addr: %llx\n", addr);
	printf("Found! State: %llx\n", state);
}

int main(void) {
	clock_t			start;
	clock_t			stop;

	// dim3	blocks(256, 256, 256);
	// dim3	threads(256);
	dim3	blocks(256*4*2, 256*4*2, 512*2);
	dim3	threads(256, 4);
	// dim3	blocks(256*4*2, 256*4*2, 1);
	// dim3	threads(256, 4);
	// dim3	blocks(1);
	// dim3	threads(1);

	start = clock();

	brute<<<blocks, threads>>>();
	CHECK(cudaGetLastError());
	CHECK(cudaDeviceSynchronize());

	stop = clock();
	std::cerr << "Took: " << ((double)(stop - start)) / CLOCKS_PER_SEC << "\n";

	return (0);
}
