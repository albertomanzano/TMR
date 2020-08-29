function [D,modes] = pesos(GS_time,Q,sv,A,epsilon)
n = length(sv);
amplitudes = zeros(n,1);
inicio = 1; %length(GS_time);
    for i = 1:n
        amplitudes(i,1) = trapz(GS_time(inicio:end),abs(A(i,inicio:end)));
    end
    sv = sv/norm(sv,2);
    amplitudes = amplitudes/norm(amplitudes,2);
    amplitudes = min(sv,amplitudes);
    logico = amplitudes>epsilon/100;
    modes = Q(:,logico);
    D = amplitudes(logico);
    