function [f11, f12, f13, f21, f22, f23] = PerezModelfParmas(epsilon)

        if (epsilon < 1.065)
            f11 = -0.008;
            f12 = 0.588;
            f13 = -0.062;
            f21 = -0.06;
            f22 = 0.072;
            f23 = -0.022;
        else
            if (epsilon < 1.23)
                f11 = 0.13;
                f12 = 0.683;
                f13 = -0.151;
                f21 = -0.019;
                f22 = 0.066;
                f23 = -0.029;
            else
                if (epsilon < 1.5)
                    f11 = 0.33;					
                    f12 = 0.487;
                    f13 = -0.221;
                    f21 = 0.055;
                    f22 = -0.064;
                    f23 = -0.026;
                else
                    if (epsilon < 1.95)
                        f11 = 0.568;
                        f12 = 0.187;
                        f13 = -0.295;
                        f21 = 0.109;
                        f22 = -0.152;
                        f23 = -0.014;
                    else
                        if (epsilon < 2.8)
                            f11 = 0.873;								
                            f12 = -0.392;
                            f13 = -0.362;
                            f21 = 0.226;
                            f22 = -0.462;
                            f23 = 0.001;
                        else
                            if (epsilon < 4.5)
                                f11 = 1.132;													
                                f12 = -1.237;
                                f13 = -0.412;
                                f21 = 0.288;
                                f22 = -0.823;
                                f23 = 0.056;
                            else
                                if (epsilon < 6.2)
                                    f11 = 1.06;	 																		
                                    f12 = -1.6;
                                    f13 = -0.359;
                                    f21 = 0.264;
                                    f22 = -1.127;
                                    f23 = 0.131;
                                else
                                    f11 = 0.678;	 																								
                                    f12 = -0.327;
                                    f13 = -0.25;
                                    f21 = 0.156;
                                    f22 = -1.377;
                                    f23 = 0.251;
                                end
                            end
                        end
                    end
                end
            end
        end
end