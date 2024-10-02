module HazardDetectionUnit(pcsrc, Mux3Sel, flush);

	input pcsrc, Mux3Sel;
	output flush;

	assign flush = (pcsrc | Mux3Sel);

endmodule
