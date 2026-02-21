///////////////////// Server Options and Boot ///////////////////////////
(
~out = 2;
s.options.memSize = 32768;
s.options.numInputBusChannels = 3;
s.options.numOutputBusChannels = 5;
s.meter(3, 5);
s.boot;
)
//////////////////////// BUS CREATION /////////////////////////////////////
(
~foudrebus = Bus.audio(s, 2);
~distobus = Bus.audio(s, 2);
~impactbus = Bus.audio(s, 2);
~groovebus = Bus.audio(s, 2);
~jolipulsesbus = Bus.audio(s, 2);
~bruitsbus = Bus.audio(s, 2);
~eaubus = Bus.audio(s, 2);
~micbus = Bus.audio(s, 2);
~rythmbus = Bus.audio(s, 2);
~nimbtaskbus = Bus.audio(s, 2);
~reverbbus = Bus.audio(s, 2);
~delaybus = Bus.audio(s, 2);

)

///////////////////// SYNTHDEFS ///////////////
(
SynthDef(\foudre, {
	arg sus, rel, atk = 0;
	var sig, dur;
	dur = sus;
	sig = SinOsc.ar(\freq.kr(400) + SinOsc.ar(Env.perc(0.001, Rand(0.5, 1.3)).ar.linlin(0, 1, 20, 800), mul:50));
	sig = sig * Env.perc(0.001, dur).ar;
	/*sig = BBandPass.ar(sig, 4000, 0.9);*/
	sig = Wrap.ar(sig * 1.8);
	sig = BBandPass.ar(sig, 500, 0.3) * 5;
	sig = Clip.ar(sig * 50);
	sig = sig + CombC.ar(sig, 2, LFNoise1.kr(1.4, 0.7, 0.2).abs, 3);
	sig = sig + HPF.ar(sig, Rand(4600, 7500), 10.5);
	sig = sig + CombC.ar(sig, 0.2, Rand(0.01, 0.4), Rand(0.5, 1.5));
	sig = sig * 1 + HPF.ar(sig, 5000,Rand(20, 60)) + LPF.ar(sig, 850, 40.5);
	sig = sig * Env([0, 1, 3, 0], [atk, dur + 2, rel]).ar(Done.freeSelf);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, Rand(70, \lpf.kr(1700)));
	sig = Pan2.ar(sig, Line.kr(Rand(-1.0, 1.0), Rand(-1.0, 1.0), dur), 0.03);
	sig = Compander.ar(sig, sig, 0.2, 0.8);
	sig = Limiter.ar(sig, -12.dbamp);
	Out.ar(~foudrebus, sig);
}).add;

SynthDef(\foudrebus, {
	var sig, noinput;
	sig = In.ar(~foudrebus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;

SynthDef(\disto, {

	var sig, dur, pan;
	dur = Rand(4.4, 8);
	pan = Rand(-1.0, 1.0);
	sig = SinOsc.ar(Env.perc(0.001, Rand(0.01, 0.2)).ar.linexp(0, 1, 20, Rand(300, 5800)));
	sig = sig * 0.45 * Env.perc(0.001, 0.5).ar;
	sig = sig + CombC.ar(sig, 0.2, Rand(0.007, 0.1), dur);
	sig = sig + DelayN.kr(CombC.ar(sig, 0.2, Rand(0.001, 0.07), dur), 0.2, Rand(0.001, 0.01));
	sig = sig * Env.perc(0.001, dur).ar(Done.freeSelf);
	sig = Clip.ar(sig * Rand(1, 100), -0.3, 0.3);
	sig = LPF.ar(sig, Rand(600, 1400)) + HPF.ar(sig, Rand(4000, 9000));
	sig = Fold.ar(sig * Rand(1, 7), -0.9, 0.9);
	// sig = Clip.ar(sig * Rand(1, 10), -0.3, 0.3);
	sig = LPF.ar(sig, Rand(100, 2500)) + HPF.ar(sig, Rand(3000, 14000));
	/*sig = sig + (CombC.ar(sig, 0.2, Rand(0.001, 0.2), dur), 0.2, Rand(0.1, 1));*/
	sig = LPF.ar(sig, Rand(2000, 4500)) + HPF.ar(sig, Rand(6000, 14000));
	sig = FreeVerb.ar(sig, Rand(0.07, 0.1), 0.3, 0.5);
	sig = HPF.ar(sig, 30);
	sig = Pan2.ar(sig, Line.kr(pan, Rand(-0.7, 0.7), Rand(0, dur)) , 0.3);
	sig = Limiter.ar(sig, -5.dbamp);
	Out.ar(~distobus, sig);
}).add;

SynthDef(\distobus, {
	var sig, noinput;
	sig = In.ar(~distobus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;

SynthDef(\impact, {
	var sig, mod, signoinput;
	mod = SinOsc.ar(\modf.kr(30), mul:\modamp.kr(1));
	sig = LFSaw.ar(Env.perc(0.001, 0.1).ar.linlin(0, 1, \freq.kr(400), 800)) + SinOsc.ar(Env.perc(0.001, 0.15).ar.linlin(0, 0.2, \freq.kr() / 2, 100) + mod, mul: 0.5);
	sig = sig * 2.5 + CombC.ar(sig, 0.2, \del.kr(0.1), \dec.kr(2));
	sig = sig + LPF.ar(sig, \lpf.kr(200),\lpfamp.kr(1));
	sig = LPF.ar(sig, 1300);
	sig = sig * Env([0, 1, 1, 0], [0.001, \dur.kr(2), \rel.kr(0.06)]).ar(Done.freeSelf);
	sig = Pan2.ar(sig, 0, -25.dbamp);
	// sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig, -5.dbamp);
	Out.ar(~impactbus, sig);
}).add;

SynthDef(\impactbus, {
	var sig, noinput;
	sig = In.ar(~impactbus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;

SynthDef(\groove, {

	var sig, dur, pan;
	dur = ExpRand(0.05, 0.5);
	pan = Rand(-1.0, 1.0);
	sig = SinOsc.ar(Env.perc(0.001, Rand(0.01, 0.2)).ar.linexp(0, 1, 20, Rand(300, 5800)));
	sig = sig * 0.45 * Env.perc(0.001, 0.5).ar;
	sig = sig + CombC.ar(sig, 0.2, Rand(0.007, 0.1), dur);
	sig = sig + DelayN.kr(CombC.ar(sig, 0.2, Rand(0.001, 0.07), dur), 0.2, Rand(0.001, 0.01));
	sig = sig * Env.perc(0.001, dur).ar(Done.freeSelf);
	sig = Clip.ar(sig * Rand(1, 100), -0.3, 0.3);
	sig = LPF.ar(sig, Rand(200, 1400)) + HPF.ar(sig, Rand(4000, 9000));
	sig = Fold.ar(sig * Rand(1, 7), -0.9, 0.9);
	// sig = Clip.ar(sig * Rand(1, 10), -0.3, 0.3);
	sig = LPF.ar(sig, Rand(100, 2500)) + HPF.ar(sig, Rand(3000, 14000));
	/*sig = sig + (CombC.ar(sig, 0.2, Rand(0.001, 0.2), dur), 0.2, Rand(0.1, 1));*/
	sig = LPF.ar(sig, Rand(2000, 4500)) + HPF.ar(sig, Rand(6000, 14000));
	sig = FreeVerb.ar(sig, Rand(0.07, 0.1), 0.3, 0.5);
	sig = HPF.ar(sig, 150);
	sig = Pan2.ar(sig, Line.kr(pan, Rand(-1.0, 1.0), Rand(0, dur)) , 0.3);
	sig = Limiter.ar(sig, -5.dbamp);
	Out.ar(~groovebus, sig);
}).add;

SynthDef(\groovebus, {
	var sig, noinput;
	sig = In.ar(~groovebus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;

SynthDef(\jolipulses, {
	var sig, env, trig, dur;
	trig = Metro.kr(SinOsc.kr(TRand.kr(0.1, 0.6), 0, rrand(5.0, 20.0), rrand(50.0, \vitmax.kr(90.0))).abs, 1);
	env = EnvGen.kr(Env.perc(TRand.kr(2, 10)* 0.001, 2),trig);
	env = env * ((LFNoise1.kr(TRand.kr(0.2, 0.5), 0.3, 0.7).abs * \amp.kr(0.5)) / \num.kr(2));
	dur = EnvGen.kr(Env([0, 1, 1, 0], [\fadein.kr(0), \dur.kr(2), \fadeout.kr(4)]), doneAction:2);
	sig = SinOsc.ar(SinOsc.kr(LFNoise1.kr(rrand(0.01, 0.2), rrand(0.01, 0.2)), mul:rrand(5.0, 8.0), add:\note.kr() * \pitch.kr(7)));
	sig = sig * env;
	sig = Pan2.ar(sig, LFNoise1.ar(TRand.kr(0.01, 0.1)), dur);
	Out.ar(~jolipulsesbus, sig);
}).add;

SynthDef(\jolipulsesbus, {
	var sig, noinput;
	sig = In.ar(~jolipulsesbus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;


SynthDef(\eau, {
	var sig, lag;
	lag = \lag.kr(0);
	sig = SinOsc.ar(\freq.kr(100, lag) + (LocalIn.ar(1) * \fbamp.kr(0)));
	sig = sig * LFNoise2.kr(0.1, 0.2, 0.8).abs;
	sig = sig + BBandPass.ar(sig, LFNoise0.kr(\fnoise.kr(40), 3000, 200).abs, LFNoise1.kr(0.5, 0.3).abs, \famp.kr(0));
	sig = sig + CombC.ar(sig, 0.5, \del.kr(0.2, lag) + LFNoise1.kr(20, 0.5).abs, \dec.kr(0.5, lag), \delamp.kr(1));
	LocalOut.ar(sig);
	sig = Pan2.ar(sig, LFNoise2.kr(0.1, 0.7),\amp.kr(0.1));
	sig = Compander.ar(sig, 1.4, 0.8, 2, 1.5) * 0.00005;
	sig = Limiter.ar(sig, -6.dbamp) * 0.8 * \mute.kr(1);
	Out.ar(~eaubus, sig);
}).add;


SynthDef(\eaubus, {
	var sig, noinput;
	sig = In.ar(~eaubus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;

SynthDef(\perc, {
	var sig, mod, env, car, randpan, startpan;
	randpan = LFNoise1.kr(0.5) * \randpan.kr(0);
	car = \carrelfreq.kr(40);
	mod = Saw.ar(car * \modindex.kr(2), Env.perc(0.01, \rel.kr * \modtimeindex.kr(0.5)).ar.linlin(0, 1, \modampmin.kr(1000), \modampmax.kr(5500)));
	env = Env.perc(0.01, \rel.kr).ar(Done.freeSelf);
	sig = SinOsc.ar((Env.perc(0.01, \sinetime.kr(0.02)).ar.linexp(0, 1, car, \caratk.kr(800))) + mod);
	sig = sig * env;
	sig = (sig * \satu.kr(3)).tanh;
	sig = Pan2.ar(sig, \pan.kr + randpan, \amp.kr(0.15));
	Out.ar(~rythmbus, sig);
}).add;

SynthDef(\blip, {
	var sig, mod, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [\atk.kr(0.001), \sus.kr(0.2), \rel.kr(0.01)]), doneAction:2);
	mod = SinOsc.ar(\modfreq.kr(400), mul:\modamp.kr(500));
	sig = SinOsc.ar(\carfreq.kr(2000) + mod);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.1));
	Out.ar(~rythmbus, sig);
}).add;

SynthDef(\rythmbus, {
	var sig, noinput;
	sig = In.ar(~rythmbus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;

SynthDef(\p,{
	arg clip = 1, amp = 2600;
	var sig, lag;
	lag = 0.2;
	sig = BBandPass.ar(WhiteNoise.ar(), \freq.kr(400, lag), \bw.kr(1, lag));
	sig = Clip.ar(sig, clip * -1, clip);
	// sig = Pan2.ar(sig, 0, amp * mute);
	sig = sig * amp;
	Out.ar(~bruitsbus, sig);
}).add;

SynthDef(\cut, {
	arg freq = 10, volume = 0.1, clip = 0.1, mute = 0, selector = 0,randpan = 1, panfreq = 1;
	var sig, trig;
	sig = In.ar(~bruitsbus, 2);
	trig = sig > 0.8;
	sig = HPF.ar(sig, freq);
	sig = Clip.ar(sig, clip * -1, clip);
	sig = Select.ar(selector, [sig * volume, Pan2.ar(sig, TIRand.kr(-1.0, 1.0, trig), volume * 1.3)]);
	sig = sig * mute;
	Out.ar(Array.series(~out, 0), sig);
}).add;

SynthDef(\noisefm, {
	arg selector = 0;
	var sig, lag;
	lag = 0.4;
	sig = SinOsc.ar((\freq.kr(560, lag) + SinOsc.ar(\mod.kr(40, lag), mul:\modamp.kr(20, lag))), mul:0.3);
	sig = BBandPass.ar(sig, \bpfreq.kr(400, lag), \bw.kr(1, lag), 1);
	sig = Clip.ar(sig * \gain.kr(1), \clip.kr(1) * -1, \clip.kr(1));
	sig = Select.ar(selector, [sig, Pan2.ar(sig, LFNoise1.kr(\panfreq.kr(0.1),1) * \panrand.kr(0), 1.3)]);
	Out.ar(0, sig * \vol.kr(0) * \mute.kr(0));
}).add;

SynthDef(\muraigu,{
	arg freq1 = 20, freq2 = 30, freq3 = 40, amp = 0, amp1 = 0, amp2 = 0, amp3 = 0, fbp = 500, bw = 1, hpfv = 1, mute = 0, out = 0;
	var sig, s1, s2, s3;
	s1 = LFSaw.ar(freq1, mul:amp1);
	s2 = LFSaw.ar(freq2, mul:amp2);
	s3 = LFSaw.ar(freq3, mul:amp3);
	sig = s1 + s2 + s3;
	sig = RHPF.ar(sig, fbp, bw, hpfv);
	sig = Pan2.ar(sig, LFNoise1.kr(0.2, 1), amp);
	sig = sig * mute;
	Out.ar(out, sig);
}).add;

SynthDef(\mic, {
	var sig, trig;
	sig = SoundIn.ar(2);
	sig = sig * 1 * \mute.kr(1);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(~micbus, sig);
}).add;

SynthDef(\micbus, {
	var sig, noinput;
	sig = In.ar(~micbus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;

SynthDef(\noinput, {
	arg vit = 1, len = 0.5, sel = 0, pan = 0, amp = 0, mode = 0, mute = 0, out = 0;
	var sig, trig;
	sig = SoundIn.ar([0, 1]);
	sig = sig * amp * mute;
	Out.ar(out, sig);
}).add;

SynthDef(\noinputenv,{
	var sig, env, trig, rate;
	env = EnvGen.kr(Env([0, 1, 1, 0], [\atk.kr(0), \sus.kr(1), \rel.kr(0)]), doneAction:2);
	sig = SoundIn.ar([0, 1]);
	sig = sig.sum;
	sig = Pan2.ar(sig, TRand.kr(-1.0, 1.0, 1), \amp.kr(1)) * env;
	Out.ar(\out.kr(~nimbtaskbus), sig);
}).add;

SynthDef(\nimbtaskbus, {
	var sig, noinput;
	sig = In.ar(~nimbtaskbus, 2);
	noinput = sig;
	Out.ar(0, sig * \amp.kr(0));
	Out.ar(2, noinput * \noinput.kr(0));
}).add;

SynthDef(\reverbbus, {
	var sig;
	sig = In.ar(~reverbbus, 2);
	sig = sig.sum;
	sig = FreeVerb.ar(sig, TRand.kr(0.5, 1, \t_reverb.kr(1)), TRand.kr(0.2, 0.8, \t_reverb.kr), \damp.kr(0.5));
	sig = Pan2.ar(sig, LFNoise1.kr(3), \amp.kr(1));
	Out.ar(~nimbtaskbus, sig);
}).add;

SynthDef(\delaybus, {
	var sig;
	sig = In.ar(~delaybus, 2);
	sig = sig.sum;
	sig = sig + CombC.ar(sig, 0.5, TRand.kr(0.01, 0.1, \tdelay.tr(1)), TRand.kr(0.2, 1.3, \tdelay.tr));
	sig = Pan2.ar(sig, LFNoise1.kr(3), \amp.kr(1));
	Out.ar(~nimbtaskbus, sig);
}).add;

SynthDef(\bufplay, {
	var sig, env;

	sig = PlayBuf.ar(1, \buf.kr, \rate.kr(1) * BufRateScale.kr(\buf.kr), 1, \spos.kr(0));
	env = EnvGen.kr(Env([0, 1, 1, 0], [\atk.kr(0), \dur.kr(0), \rel.kr(0)]), doneAction:2);
	sig = Pan2.ar(sig, Rand(-1.0, 1.0), env * \amp.kr(1));
	Out.ar(\out.kr(~nimbtaskbus), sig);
}).add;
)

/////////////////////// TASKS AND ROUTINE /////////////

(
~foudreamp = Synth(\foudrebus);
~distoamp = Synth(\distobus);
~impactamp = Synth(\impactbus);
~grooveamp = Synth(\groovebus);
~jolipulsesamp = Synth(\jolipulsesbus);
~eauamp = Synth(\eaubus);
~micamp = Synth(\micbus);
~nimbtaskamp = Synth(\nimbtaskbus);
~eauson = Synth(\eau, [\freq, 100, \amp, 0.2]);
~eauprob = [1, 0, 0, 0];
~rythmamp = Synth(\rythmbus);
~bpm = 110;
~nimbdurmax = 0.001;
~nimbwait = 0;
~reverb = Synth(\reverbbus);
~delay = Synth(\delaybus);
~foudrelpf = 700;
~foudredensity = 5;
t = TempoClock.new(~bpm/60);

~foudre = Task({
	loop{
		var atk = rrand(0, 2.0);
		var dur = rrand(3, 5.5);
		var rel = rrand(2, 4.5);
	[45,59, 67, 32].do({arg i; Synth(\foudre, [\freq, i.midicps, \sus, dur - rel, \rel, rel, \atk, atk, \lpf, ~foudrelpf]);});
		rrand(1.0, ~foudredensity).wait;
	};
});

~disto = Task({
	loop {
		Synth(\disto);
		rrand(0.5, 5).wait;
	}
});

~impact = Task({
	loop{
		Synth(\impact, [\freq, 50, \modf, 20, \modamp, 550, \del, rrand(0.05, 0.1), \dec, 30, \dur, rrand(1.0, 3), \rel, rrand(3.0, 5), \lpf, 200, \lpfamp, 3]);
		rrand(8.0, 13.0).wait;
	};
});

~groove = {
	loop {

		s.bind { Synth(\groove) };
		(1 / 4).wait;
	}
};

~jolipulses = Task({

	~jolipulsespitch = 1;
	loop {
		var num;
		num = rrand(4, 12);
	num.do({
			Synth(\jolipulses, [\note, ([405, 310, 550, 666, 355, 700, 498].choose + rrand(2.0, 7.0)), \fadein, rrand(8.0, 17.0), \dur, rrand(18.0, 28.0), \rel, rrand(8.0, 12.0), \num, num, \amp,1.5, \pitch, ~jolipulsespitch]);
		});
		rrand(30, 40).wait;
};
});

~eau = Task({

	loop{
		var rand;
		rand = [0, 1, 2, 3].wchoose(~eauprob);
		if(rand == 0, {~eauson.set(\fbamp, rrand(0.5, 1.8), \freq, rrand(5, 10), \del, 0.007, \dec, 0.1, \fnoise, 800, \amp, -36.dbamp, \delamp, 1, \famp, 0.5, \amp, 0.08);});
		if(rand == 1, {~eauson.set(\fbamp, 800, \freq, rrand(1400, 2800), \del, 0.1, \dec, 0.3, \fnoise, 400, \amp, -36.dbamp, \delamp, 3.8, \famp, 5, \amp, 0.06);});
		if(rand==2, {~eauson.set(\fbamp, rrand(700, 800), \freq, 0.4, \del, 0.008, \dec, 30, \fnoise, 40, \amp, -36.dbamp, \delamp, 0.8, \famp, 5, \amp, 0.06);});
		if(rand==3, {~eauson.set(\fbamp, rrand(800, 1900), \freq, 0.4, \del, 0.08, \dec, 0.3, \fnoise, 0.4, \amp, -36.dbamp, \delamp, 0.8, \famp, 5, \amp, 0.06);});

		rrand(0.001, 0.06).wait;
};

});

~rythmQuant = {
	loop {

		var dur, synth, bpm, beat;

		synth = [0, 1, 2, 3].wchoose([0.8, 0.08, 0.4, 0.05].normalizeSum);
		case
		{synth == 0} {s.bind {Synth(\perc, [\modindex, rrand(0.5, 0.8), \modampmax, rrand(8500, 16000),\modampmin, 500, \modtimeindex, rrand(0.2, 1.5), \rel, rrand(0.1, 0.5) , \carrelfreq, 400, \caratk, rrand(800, 2800), \amp, rrand(0.10, 0.14), \pan, rrand(-0.7, 0.7)])};dur = [1/4, 1/2].wchoose([0.9, 0.1])}

		{synth == 1} {s.bind {Synth(\blip, [\carfreq, 15000, \modfreq, rrand(700, 1400), \modamp, rrand(8000, 12000), \pan, rrand(-0.8, 0.8), \amp, rrand(0.03, 0.04)])}; dur = [1/4, 1/2].choose}

		{synth == 2} {s.bind {Synth(\perc, [\modindex, [rrand(4.0, 7.0), 5].choose, \modampmax, 5500,\modampmin, 500, \modtimeindex, 0.2, \rel, 2, \carrelfreq, 40, \caratk, 600, \amp, 0.3, \randpan, 1])};dur = [1 * 2, 1 / 2, 1, 1 / 4, 1 * 8].choose;}

		{synth == 3} {s.bind {Synth(\perc, [\modindex, [1, 0.95].choose, \modampmax, 400,\modampmin, rrand(1000, 1600), \modtimeindex, 0.2, \rel, 5, \carrelfreq, 40, \caratk, 300, \sinetime, 0.01, \satu, 1, \amp, 0.25, \randpan, 1])};dur = [1 * 2, 1 * 4, 1 * 8].choose;};


		dur.wait;
	};
};

~rythmUnquant = Task({
	loop {

		var dur, synth;

		synth = [0, 1, 2, 3].wchoose([0.8, 0.08, 0.07, 0.05]);
		case
		{synth == 0} {Synth(\perc, [\modindex, rrand(0.5, 0.8), \modampmax, rrand(8500, 16000),\modampmin, 500, \modtimeindex, rrand(0.2, 1.5), \rel, rrand(0.1, 0.5) , \carrelfreq, 400, \caratk, rrand(800, 2800), \amp, rrand(0.10, 0.14), \pan, rrand(-0.7, 0.7)]);dur = [rrand(0.01, 0.3), rrand(0.5, 1), rrand(1.5, 4)].wchoose([0.8, 0.15, 0.05])}

		{synth == 1} {Synth(\blip, [\carfreq, 15000, \modfreq, rrand(700, 1400), \modamp, rrand(8000, 12000), \pan, rrand(-0.8, 0.8), \amp, rrand(0.02, 0.03)]); dur = rrand(0.1, 0.3)}

		{synth == 2} {Synth(\perc, [\modindex, [rrand(4.0, 7.0), 5].choose, \modampmax, 5500,\modampmin, 500, \modtimeindex, 0.2, \rel, 2, \carrelfreq, 40, \caratk, 600, \amp, 0.3, \randpan, 1]);dur = rrand(0.5, 6);}

		{synth == 3} {Synth(\perc, [\modindex, [1, 0.95].choose, \modampmax, 400,\modampmin, rrand(1000, 1600), \modtimeindex, 0.2, \rel, 5, \carrelfreq, 40, \caratk, 300, \sinetime, 0.01, \satu, 1, \amp, 0.25, \randpan, 1]);dur = rrand(2.0, 7.0);};


		dur.wait;
	};
});

~noinputenv = Task({

	loop {

	var dur, buf, choice;
		buf = rand(2);
		dur = rrand(0.001, ~nimbdurmax);
		choice = rand(2);
		case
		{choice == 0} {
		Synth(\noinputenv, [\sus, dur, \amp, 0.7, \out, [~nimbtaskbus, ~reverbbus, ~delaybus].choose]);
		~reverb.set(\t_reverb, 1);
		~delay.set(\tdelay, 1);
		}
		{choice == 1} {
			Synth(\bufplay, [\buf, b[buf], \dur, dur, \spos, rrand(0, b[buf].numFrames), \out, [~nimbtaskbus, ~reverbbus, ~delaybus].choose, \rate, 1]);
		~reverb.set(\t_reverb, 1);
		~delay.set(\tdelay, 1);
		};
		rrand(dur, dur + ~nimbwait;).wait;
	};
});


~cut = Synth(\cut);
~bruit1 = Synth(\p);
~bruit2 = Synth(\p);
~bruit3 = Synth(\p);
~fmnoise1 = Synth(\noisefm);
~fmnoise2 = Synth(\noisefm);
~muraigu = Synth(\muraigu, [ \freq1, 40, \freq2, 8, \freq3, 70,\amp1, 0.6, \amp2, 0.45, \amp3, 0.38,\bw, 0.2, \hpfv, 3, \fbp, 9000,\amp, 0, \mute, 1]);
~mic = Synth(\mic);
~noinput = Synth(\noinput);
)



/////////////////////////////////////////// GUI //////////////////////

Window.closeAll;
(
w = Window.new("gui", Rect(1200, 800, 1000, 1000));
w.front.alwaysOnTop_(true);
w.view.decorator_(FlowLayout(w.bounds, 20@20, 25@25));
~tasksgui = Array.fill(9, {
	arg i, view;
	case
	{i == 5} {view = CompositeView(w, 85@500).background_(Color.rand);
		view.decorator_(FlowLayout(view.bounds, 8@8, 10@10));}
	{i > 5} {view = CompositeView(w, 150@425).background_(Color.rand);
		view.decorator_(FlowLayout(view.bounds, 25@10, 20@25));}
	{
	view = CompositeView(w, 150@500).background_(Color.rand);
	view.decorator_(FlowLayout(view.bounds, 25@10, 20@25));
	};

});
5.do({arg i; Array.fill(2, {arg n;var color;if(n == 0, {color = Color.new(0,0.7)}, {color = Color.new(0.7)}); Slider(~tasksgui[i], 40@300).background_(color)})});
5.do({arg i; Array.fill(2, {Knob(~tasksgui[i], 40@40).mode_(\vert).keystep_(0.0001)})});
5.do({arg i; Button(~tasksgui[i], 100@80)});

Array.fill(2, {arg n;var color;if(n == 0, {color = Color.new(0,0.7)}, {color = Color.new(0.7)}); Slider(~tasksgui[6], 40@280).background_(color)});
TextField(~tasksgui[6], 100@30);
Button(~tasksgui[6], 100@40);

Array.fill(2, {arg n;var color;if(n == 0, {color = Color.new(0,0.7)}, {color = Color.new(0.7)}); Slider(~tasksgui[7], 40@280).background_(color)});
Button(~tasksgui[7], 100@40);
Button(~tasksgui[7], 100@40);

Array.fill(2, {arg n;var color;if(n == 0, {color = Color.new(0,0.7)}, {color = Color.new(0.7)}); Slider(~tasksgui[8], 40@300).background_(color)});
Button(~tasksgui[8], 100@80);


~tasksgui[0].children[4].states_([
	["Foudre", Color.black, Color.white],
	["Foudre", Color.white, Color.new(0.65)]
]);
~tasksgui[1].children[4].states_([
	["Disto", Color.black, Color.white],
	["Disto", Color.white, Color.new(0.65)]
]);
~tasksgui[2].children[4].states_([
	["Impact", Color.black, Color.white],
	["Impact", Color.white, Color.new(0.65)]
]);
~tasksgui[3].children[4].states_([
	["Groove", Color.black, Color.white],
	["Groove", Color.white, Color.new(0.65)]
]);
~tasksgui[4].children[4].states_([
	["JoliesPulses", Color.black, Color.white],
	["JoliesPulses", Color.white, Color.new(0.65)]
]);

~tasksgui[6].children[3].states_([
	["Eau", Color.black, Color.white],
	["Eau", Color.white, Color.new(0.65)]
]);

~tasksgui[7].children[2].states_([
	["RythmQuant", Color.black, Color.white],
	["RythmQuant", Color.white, Color.new(0.65)]
]);

~tasksgui[7].children[3].states_([
	["RythmUnquant", Color.black, Color.white],
	["RythmUnquant", Color.white, Color.new(0.65)]
]);

~tasksgui[8].children[2].states_([
	["Mic", Color.black, Color.white],
	["Mic", Color.white, Color.new(0.65)]
]);


//Boutons
~tasksgui[0].children[4].action_({|v| if(v.value == 1,{~foudre.start;}, {~foudre.stop;};);});
~tasksgui[1].children[4].action_({|v| if(v.value == 1,{~disto.start;}, {~disto.stop;};);});
~tasksgui[2].children[4].action_({|v| if(v.value == 1,{~impact.start;}, {~impact.stop;};);});
~tasksgui[3].children[4].action_({|v| if(v.value == 1,{~grout = ~groove.r.play(clock: t, quant:0.25);}, {~grout.stop;};);});
~tasksgui[4].children[4].action_({|v| if(v.value == 1,{~jolipulses.start;}, {~jolipulses.stop;};);});
~tasksgui[6].children[3].action_({|v| if(v.value == 1,{~eauson.set(\mute, 1);~eau.start;}, {~eauson.set(\mute, 0);~eau.stop;};);});
~tasksgui[7].children[2].action_({|v| if(v.value == 1,{~rqrout = ~rythmQuant.r.play(clock: t, quant:0.25);}, {~rqrout.stop;};);});
~tasksgui[7].children[3].action_({|v| if(v.value == 1,{~rythmUnquant.start;}, {~rythmUnquant.stop;};);});
~tasksgui[8].children[2].action_({|v| if(v.value == 1,{~mic.set(\mute, 1);}, {~mic.set(\mute, 0);};);});
~rythmQuant.reset;

//Knobs
~tasksgui[0].children[2].action_({|v| ~foudredensity = v.value.linlin(0, 1, 0.5, 8);});
~tasksgui[0].children[3].action_({|v| ~foudrelpf = v.value.linlin(0, 1, 60, 5000);});

//Sliders
~tasksgui[0].children[0].action_({|v| ~foudreamp.set(\amp, v.value.linexp(0, 1, 0.001, 1) - 0.001);});
~tasksgui[0].children[1].action_({|v| ~foudreamp.set(\noinput,v.value.linexp(0, 1, 0.001, 1) - 0.001)});
~tasksgui[1].children[0].action_({|v| ~distoamp.set(\amp, v.value.linexp(0, 1, 0.001, 1) - 0.001);});
~tasksgui[1].children[1].action_({|v| ~distoamp.set(\noinput, v.value.linexp(0, 1, 0.001, 1) - 0.001)});
~tasksgui[2].children[0].action_({|v| ~impactamp.set(\amp, v.value.linexp(0, 1, 0.001, 1) - 0.001);});
~tasksgui[2].children[1].action_({|v| ~impactamp.set(\noinput, v.value.linexp(0, 1, 0.001, 1) - 0.001);});
~tasksgui[3].children[0].action_({|v| ~grooveamp.set(\amp, v.value.linexp(0, 1, 0.001, 1) - 0.001);});
~tasksgui[3].children[1].action_({|v| ~grooveamp.set(\noinput, v.value.linexp(0, 1, 0.001, 1) - 0.001);});
~tasksgui[4].children[0].action_({|v| ~jolipulsesamp.set(\amp, v.value.linexp(0, 1, 0.001, 1.5) - 0.001);});
~tasksgui[4].children[1].action_({|v| ~jolipulsesamp.set(\noinput, v.value.linexp(0, 1, 0.001, 1.5) - 0.001);});
~tasksgui[6].children[0].action_({|v| ~eauamp.set(\amp, v.value.linexp(0, 1, 0.001, 1) - 0.001);});
~tasksgui[6].children[1].action_({|v| ~eauamp.set(\noinput, v.value.linexp(0, 1, 0.001, 1) - 0.001);});
~tasksgui[7].children[0].action_({|v| ~rythmamp.set(\amp, v.value.linexp(0, 1, 0.001, 1.5) - 0.001);});
~tasksgui[7].children[1].action_({|v| ~rythmamp.set(\noinput, v.value.linexp(0, 1, 0.001, 1.5) - 0.001);});
~tasksgui[8].children[0].action_({|v| ~micamp.set(\amp, v.value.linexp(0, 1, 0.001, 1.5) - 0.001);});
~tasksgui[8].children[1].action_({|v| ~micamp.set(\noinput, v.value.linexp(0, 1, 0.001, 1.5) - 0.001);});

Array.fill(4, {
	Button(~tasksgui[5], 70@20);
		Knob(~tasksgui[5], 70@70).background_(Color.rand).mode_(\vert).keystep_(0.0001);
});
~tasksgui[5].children[6].states_([
	["NimbEnv", Color.black, Color.white],
	["NimbEnv", Color.white, Color.new(0.65)]
]);

~tasksgui[5].children[3].action_({|v|  ~nimbdurmax = (v.value.linlin(0, 1, 0.001, 1.6))});
~tasksgui[5].children[5].action_({|v|  ~nimbwait = (v.value.linlin(0, 1, 0.001, 4.6) - 0.001)});
~tasksgui[5].children[6].action_({|v| if(v.value == 1,{~noinputenv.start;}, {~noinputenv.stop;};);});
~tasksgui[5].children[7].action_({|v| ~nimbtaskamp.set(\amp, (v.value.linexp(0, 1, 0.1, 1.6) - 0.1))});


//TextField Eau

~tasksgui[6].children[2].action_({|v| ("~eauprob =" ++ "[" ++ v.value ++ "]").interpret ;~eauprob.normalizeSum.postln;});



	~task1clean = false;
	~task1noinput = false;
	~task2clean = false;
	~task2noinput = false;
	~task3clean = false;
	~task3noinput = false;
	~task4clean = false;
	~task4noinput = false;
	~task5clean = false;
	~task5noinput = false;
	~task6clean = false;
	~task6noinput = false;
	~task7clean = false;
	~task7noinput = false;
	~task8clean = false;
	~task8noinput = false;

// Controls Mouse and Keyboard

x = Window.new("controls", Rect(0, 0, 300, 300)).front.alwaysOnTop_(true);

x.view.keyDownAction = {

	arg view, char, modifiers, unicode, keycode;

	// Start/stop:


	if( (char == $a).and(modifiers == 0), {~tasksgui[0].children[4].valueAction_(1 - ~tasksgui[0].children[4].value)});

	if( (char == $z).and(modifiers == 0), {~tasksgui[1].children[4].valueAction_(1 - ~tasksgui[1].children[4].value)});

	if( (char == $e).and(modifiers == 0), {~tasksgui[2].children[4].valueAction_(1 - ~tasksgui[2].children[4].value)});

	if( (char == $r).and(modifiers == 0), {~tasksgui[3].children[4].valueAction_(1 - ~tasksgui[3].children[4].value)});

	if( (char == $t).and(modifiers == 0), {~tasksgui[4].children[4].valueAction_(1 - ~tasksgui[4].children[4].value)});

	if( (char == $q).and(modifiers == 0), {~tasksgui[6].children[3].valueAction_(1 - ~tasksgui[6].children[3].value)});

	if( (char == $s).and(modifiers == 0), {~tasksgui[7].children[2].valueAction_(1 - ~tasksgui[7].children[2].value)});

	if( (char == $x).and(modifiers == 0), {~tasksgui[7].children[3].valueAction_(1 - ~tasksgui[7].children[3].value)});

	if( (char == $d).and(modifiers == 0), {~tasksgui[8].children[2].valueAction_(1 - ~tasksgui[8].children[2].value)});

	if( (char == $f).and(modifiers == 0), {~tasksgui[5].children[6].valueAction_(1 - ~tasksgui[5].children[6].value)});


	// Clean

		if( (char == $A).and(modifiers == 131072), {
		~task1clean = ~task1clean.not;
		("Foudre " ++ ~task1clean.value).postln;
	});

	if( (char == $Z).and(modifiers == 131072), {
		~task2clean = ~task2clean.not;
		("Disto " ++ ~task2clean.value).postln;
	});

	if( (char == $E).and(modifiers == 131072), {
		~task3clean = ~task3clean.not;
		("Impact " ++ ~task3clean.value).postln;
	});

	if( (char == $R).and(modifiers == 131072), {
		~task4clean = ~task4clean.not;
		("Groove " ++ ~task4clean.value).postln;
	});

	if( (char == $T).and(modifiers == 131072), {
		~task5clean = ~task5clean.not;
		("JoliesPulses " ++ ~task5clean.value).postln;
	});

	if( (char == $Q).and(modifiers == 131072), {
		~task6clean = ~task6clean.not;
		("Eau " ++ ~task6clean.value).postln;
	});

	if( (char == $S).and(modifiers == 131072), {
		~task7clean = ~task7clean.not;
		("Rythm " ++ ~task7clean.value).postln;
	});

	if( (char == $D).and(modifiers == 131072), {
		~task8clean = ~task8clean.not;
		("Mic " ++ ~task8clean.value).postln;
	});

	// Noinput

		if( (char == $a).and(modifiers == 524288), {
		~task1noinput = ~task1noinput.not;
		("Foudre " ++ ~task1noinput.value).postln;
	});

	if( (char == $z).and(modifiers == 524288), {
		~task2noinput = ~task2noinput.not;
		("Disto " ++ ~task2noinput.value).postln;
	});

	if( (char == $e).and(modifiers == 524288), {
		~task3noinput = ~task3noinput.not;
		("Impact " ++ ~task3noinput.value).postln;
	});

	if( (char == $r).and(modifiers == 524288), {
		~task4noinput = ~task4noinput.not;
		("Groove " ++ ~task4noinput.value).postln;
	});

	if( (char == $t).and(modifiers == 524288), {
		~task5noinput = ~task5noinput.not;
		("JoliesPulses " ++ ~task5noinput.value).postln;
	});

	if( (char == $q).and(modifiers == 524288), {
		~task6noinput = ~task6noinput.not;
		("Eau " ++ ~task6noinput.value).postln;
	});

	if( (char == $s).and(modifiers == 524288), {
		~task7noinput = ~task7noinput.not;
		("Rythm " ++ ~task7noinput.value).postln;
	});

	if( (char == $d).and(modifiers == 524288), {
		~task8noinput = ~task8noinput.not;
		("Mic " ++ ~task8noinput.value).postln;
	});

x.view.mouseDownAction = {
	arg view, x, y, modifiers, buttonNumber, clickCount;
	~mouseYpos = y.linlin(0, 400, 1, 0);
	~mousebutton = buttonNumber;
};

x.view.mouseMoveAction = {
	arg view, x, y, modifiers;
	~mouseYvalue = y.linlin(0, 400, 1, 0) - ~mouseYpos;
	//~mouseYvalue.postln;

		if(~task1clean == true, {~tasksgui[0].children[0].valueAction_(~tasksgui[0].children[0].value + (~mouseYvalue.value / 100))});
		if(~task2clean == true, {~tasksgui[1].children[0].valueAction_(~tasksgui[1].children[0].value + (~mouseYvalue.value / 100))});
		if(~task3clean == true, {~tasksgui[2].children[0].valueAction_(~tasksgui[2].children[0].value + (~mouseYvalue.value / 100))});
		if(~task4clean == true, {~tasksgui[3].children[0].valueAction_(~tasksgui[3].children[0].value + (~mouseYvalue.value / 100))});
		if(~task5clean == true, {~tasksgui[4].children[0].valueAction_(~tasksgui[4].children[0].value + (~mouseYvalue.value / 100))});
		if(~task6clean == true, {~tasksgui[6].children[0].valueAction_(~tasksgui[6].children[0].value + (~mouseYvalue.value / 100))});
		if(~task7clean == true, {~tasksgui[7].children[0].valueAction_(~tasksgui[7].children[0].value + (~mouseYvalue.value / 100))});
		if(~task8clean == true, {~tasksgui[8].children[0].valueAction_(~tasksgui[8].children[0].value + (~mouseYvalue.value / 100))});

		if(~task1noinput == true, {~tasksgui[0].children[1].valueAction_(~tasksgui[0].children[1].value + (~mouseYvalue.value / 100))});
		if(~task2noinput == true, {~tasksgui[1].children[1].valueAction_(~tasksgui[1].children[1].value + (~mouseYvalue.value / 100))});
		if(~task3noinput == true, {~tasksgui[2].children[1].valueAction_(~tasksgui[2].children[1].value + (~mouseYvalue.value / 100))});
		if(~task4noinput == true, {~tasksgui[3].children[1].valueAction_(~tasksgui[3].children[1].value + (~mouseYvalue.value / 100))});
		if(~task5noinput == true, {~tasksgui[4].children[1].valueAction_(~tasksgui[4].children[1].value + (~mouseYvalue.value / 100))});
		if(~task6noinput == true, {~tasksgui[6].children[1].valueAction_(~tasksgui[6].children[1].value + (~mouseYvalue.value / 100))});
		if(~task7noinput == true, {~tasksgui[7].children[1].valueAction_(~tasksgui[7].children[1].value + (~mouseYvalue.value / 100))});
		if(~task8noinput == true, {~tasksgui[8].children[1].valueAction_(~tasksgui[8].children[1].value + (~mouseYvalue.value / 100))});
};
};
)

MIDIFunc.trace(true);
MIDIIn.connectAll;
(

///// MIDI CONTROLS FOR SYNTHS /////


MIDIdef.cc(\midimix, {

	arg v, num, chan, src;
	case
	//1 row
	{num == 16 && chan == 0} {~bruit1.set(\freq, v.value.linexp(0, 127, 40, 20000));}
	{num == 17 && chan == 0} {~bruit2.set(\freq, v.value.linexp(0, 127, 40, 20000));}
	{num == 18 && chan == 0} {~bruit3.set(\freq, v.value.linexp(0, 127, 40, 20000));}
	{num == 19 && chan == 0} {~cut.set(\volume, v.value.linexp(0, 127, 0.001, 3) - 0.001);}

	//2 row
	{num == 20 && chan == 0} {~bruit1.set(\bw, v.value.linexp(0, 127, 0.00001, 30));}
	{num == 21 && chan == 0} {~bruit2.set(\bw, v.value.linexp(0, 127, 0.00001, 30));}
	{num == 22 && chan == 0} {~bruit3.set(\bw, v.value.linexp(0, 127, 0.00001, 30));}
	{num == 23 && chan == 0} {~cut.set(\freq, v.value.linexp(0, 127, 10, 18000));}

	//3 row
	{num == 24 && chan == 0} {~fmnoise1.set(\freq, v.value.linexp(0, 127, 10, 20000));}
	{num == 25 && chan == 0} {~fmnoise1.set(\mod, v.value.linexp(0, 127, 8, 20000));}
	{num == 26 && chan == 0} {~fmnoise1.set(\bpfreq, v.value.linexp(0, 127, 8, 20000));}
	{num == 27 && chan == 0} {~fmnoise1.set(\vol, v.value.linexp(0, 127, 0.001, 1) - 0.001);}

	//4 row
	{num == 28 && chan == 0} {~fmnoise1.set(\panfreq, v.value.linlin(0, 127, 0.2, 10));}
	{num == 29 && chan == 0} {~fmnoise1.set(\modamp, v.value.linexp(0, 127, 10, 40000));}
	{num == 30 && chan == 0} {~fmnoise1.set(\bw, v.value.linexp(0, 127, 0.00001, 200));}
	{num == 31 && chan == 0} {~fmnoise1.set(\clip, v.value.linexp(0, 127, 0.00001, 1));}

	//5 row
	{num == 46 && chan == 0} {~fmnoise2.set(\freq, v.value.linexp(0, 127, 10, 20000));}
	{num == 47 && chan == 0} {~fmnoise2.set(\mod, v.value.linexp(0, 127, 8, 20000));}
	{num == 48 && chan == 0} {~fmnoise2.set(\bpfreq, v.value.linexp(0, 127, 8, 20000));}
	{num == 49 && chan == 0} {~fmnoise2.set(\vol, v.value.linexp(0, 127, 0.001, 1) - 0.001);}

	//6 row
	{num == 50 && chan == 0} {~fmnoise2.set(\panfreq, v.value.linlin(0, 127, 0.2, 10));}
	{num == 51 && chan == 0} {~fmnoise2.set(\modamp, v.value.linexp(0, 127, 10, 40000));}
	{num == 52 && chan == 0} {~fmnoise2.set(\bw, v.value.linexp(0, 127, 0.00001, 200));}
	{num == 53 && chan == 0} {~fmnoise2.set(\clip, v.value.linexp(0, 127, 0.00001, 1));}

	//7 row
	{num == 54 && chan == 0} {~muraigu.set(\freq1, v.value.linexp(0, 127, 5, 500));}
	{num == 55 && chan == 0} {~muraigu.set(\freq2, v.value.linexp(0, 127, 5, 500));}
	{num == 56 && chan == 0} {~muraigu.set(\freq3, v.value.linexp(0, 127, 5, 500));}
	{num == 57 && chan == 0} {~muraigu.set(\amp, v.value.linexp(0, 127, 0.00001, 0.4) - 0.00001);}

	//8 row
	{num == 58 && chan == 0} {nil}
	{num == 59 && chan == 0} {nil}
	{num == 60 && chan == 0} {nil}
	{num == 61 && chan == 0} {~noinput.set(\amp, (v.value.linexp(0, 127, 0.1, 1.6) - 0.1));}

	//Master
	{num == 62 && chan == 0} {nil}



}, srcID:MIDIClient.sources.detect { |e| e.device.containsi("MIDI Mix")}.uid);

MIDIdef.noteOn(\midimixnoteOn, {
	arg v, num, chan, src;
	case
	// Row 1
	{num == 1 && chan == 0} {~cut.set(\mute, 0);}
	{num == 3 && chan == 0} {~cut.set(\mute, 1);}

	// Row 2
	{num == 4 && chan == 0} {~cut.set(\randpan, 0, \selector, 0);}
	{num == 6 && chan == 0} {~cut.set(\randpan, 1, \selector, 1);}

	// Row 3
	{num == 7 && chan == 0} {~fmnoise1.set(\mute, 0);}
	{num == 9 && chan == 0} {~fmnoise1.set(\mute, 1);}

	// Row 4
	{num == 10 && chan == 0} {~fmnoise1.set(\panrand, 0, \selector, 0);}
	{num == 12 && chan == 0} {~fmnoise1.set(\panrand, 1, \selector, 1);}

	//Row 5
	{num == 13 && chan == 0} {~fmnoise2.set(\mute, 0);}
	{num == 15 && chan == 0} {~fmnoise2.set(\mute, 1);}

	//Row 6
	{num == 16 && chan == 0} {~fmnoise2.set(\panrand, 0, \selector, 0);}
	{num == 18 && chan == 0} {~fmnoise2.set(\panrand, 1, \selector, 1);}

	//Row 7
	{num == 19 && chan == 0} {~muraigu.set(\mute, 0);}
	{num == 21 && chan == 0} {~muraigu.set(\mute, 1);}

	//Row 8
	{num == 22 && chan == 0} {~noinput.set(\mute, 0);}
	{num == 24 && chan == 0} {~noinput.set(\mute, 1);}

	//Row bank left/right and solo
	{num == 25 && chan == 0} {nil}
	{num == 26 && chan == 0} {nil}
	{num == 27 && chan == 0} {nil}


} srcID:MIDIClient.sources.detect { |e| e.device.containsi("MIDI Mix")}.uid);
)