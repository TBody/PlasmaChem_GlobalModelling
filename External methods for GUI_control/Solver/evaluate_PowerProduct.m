function NewVector = evaluate_PowerProduct(Matrix,Vector)
	MatrixDimensions = size(Matrix);
	if length(Vector) ~= MatrixDimensions(2)
		error('evaluate_PowerProduct requires matrix row length to equal vector length')
	end
	NewVector = zeros(MatrixDimensions(1),1); %ColumnVector
	for RowIndex = 1:MatrixDimensions(1)
		NewVector(RowIndex) = prod((Vector').^Matrix(RowIndex,:));
	end
end