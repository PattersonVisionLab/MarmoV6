function trialsList = Featrans_TrialsList( S, P )
%trialsList = Featrans_TrialsList(S,P)
%    S - struct of psychtoolbox settings parameters
%    P - struct of protocol parameters
%  Returns trialsList - list of parameters to substitute over trials

        %******** HERE FOR REFERENCE, JUST LIST THE FIELDS OF LIST
        %   Field 1, 2:   xpos and ypos of target
        %   Field 3:      orientation of target stimulus
        %   Field 4:      size of juice reward (based on condition)
        %   Field 5:      post-saccade orientation (NaN if blank)
        %   Field 6:      flash probe or not
        
        % Eccentricity sampling, currently only using the radius specified above
        rad = norm([P.xDeg P.yDeg],2);
        % Generate trials list ... note, you may wish to generate the list
        %*****      after changing some P type parameters
        trialsList = [];
           
        for zzk = 1:2   % balance two target directions, clockwise and counter  
            %*******
            for ak = 1:(4*P.orinum)  % fourths, 1/2 same (1/4 no probe, 1/4 probe)
                                   %          1/2 rand (1/4 no probe, 1/4 probe)
                   %************
                   ora = NaN;  % default, probe same surface direction (change on expected surface)
                   if (ak > (2*P.orinum))
                       tat = mod((ak-1),P.orinum);
                       ora = tat * 360 / P.orinum;  % select random direction of probe
                   end
                   if (mod(ak-1,(2*P.orinum)) < P.orinum)
                       probe = 0;
                   else
                       probe = 1;  % show contrast flash on probe dots
                   end
                   %******** sample each of the possible locations
                   for k = 1:P.targnum     % sample from RF and other locations
                       %************  
                       xps = P.RF_X;
                       yps = P.RF_Y;
                       %*******
                       ango = 2*pi*(k-1)/P.targnum;  % shift the position
                       xpos = (cos(ango) * xps) + (sin(ango) * yps);
                       ypos = (-sin(ango) * xps) + (cos(ango) * yps);
                       
                       %***** Added by Sunwoo .... compute tangent direction
                       if (xpos >= 0)
                            ango = atan(ypos/xpos);
                       else
                            if (ypos > 0)
                                ango = atan(ypos/xpos) + pi;
                            else
                                ango = atan(ypos/xpos) - pi;
                            end
                       end
                       ango = ango/pi*180; % Convert back to degrees
                       if (zzk == 1)
                           oro = ango + 90;  %clockwise
                       else
                           oro = ango - 90; % counter-clock
                       end
                       %****** make bound from 0 to 360
                       if (oro < 0)
                          oro = oro + 360;
                       end
                       if (oro > 360)
                          oro = oro - 360;
                       end
                       %********
  
                       % Trials list is comprised of varied params per trial
                       % note, oro - is not direction, but an integer for
                       %             the 2^targnum possible (clock vs
                       %             counter clock) direction starts
                       % then, ora - is NaN for the same as targets, or 1
                       %             of P.orinum random directions tested
                       % and last, added probe - if one a contrast flash
                       trialsList = [trialsList ; [xpos ypos oro P.rewardNumber ora probe]];

                   end  % for position        % x 4 condts
            end  % for 4 variants for probe motions, % x 4x8, 32
        end  % for permutations of start motion, 2^4 is 16
        %************
end

