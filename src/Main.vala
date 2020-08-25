
/*
	
	meson build --prefix=/usr
	ninja
	
*/

public static int main(string[] args) {

    TradeSim.Application AppTradeSim = new TradeSim.Application() ;

    return AppTradeSim.run (args);

}
