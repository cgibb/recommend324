def pdf(mean, ssd, x)
	# Computes P(x|y). Ported from GTDM.
	ePart = Math.exp(-(x - mean) ** 2 / (2 * ssd ** 2))
	return (1.0 / (Math.sqrt(2*math.pi)*ssd)) * ePart
end
