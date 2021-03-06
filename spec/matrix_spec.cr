require "./spec_helper"
require "benchmark"
describe Matrix do
  context "creation" do
    it "creates a Matrix from given columns" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]

      m[0, 0].should eq(1)
      m[0, 1].should eq(2)
      m[1, 0].should eq(3)
      m[1, 1].should eq(4)
    end

    it "loads from space separated file" do
      m = Matrix.load "spec/housing.data"

      m.number_of_rows.should eq(506)
      m.number_of_cols.should eq(14)

      m[0, 0].should eq(0.00632)
      m[6, 0].should eq(0.08829)
      m[15, 0].should eq(0.62739)
      m[0, 1].should eq(18.0)
      m[99, 2].should eq(2.890)
      m[112, 11].should eq(394.95)
    end
  end

  context "dimensions" do
    it "with same number of cols and rows" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      m.dimensions.should eq({2,2})
    end

    it "with different number of cols and rows" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0], [1.0, 3.0], [2.0, 4.0]]
      m.dimensions.should eq({2,4})
    end
  end

  context "comparison" do
    it "checks two matrices are equal" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      m2 = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]

      m.should eq(m2)
    end

    it "checks two matrices are not equal" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      m2 = Matrix.columns [[3.0, 3.0], [2.0, 4.0]]

      m.should_not eq(m2)
    end

    it "with similar matrixes" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      m2 = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      m.all_close(m2).should be_true
    end

    it "with matrixes with different dimensions" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      m2 = Matrix.columns [[1.0, 3.0], [2.0, 4.0], [3.0, 5.0]]
      m.all_close(m2).should be_false
    end

    it "with matrixes with same dimensions and different values" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      m2 = Matrix.columns [[1.0, 5.0], [2.0, 4.0]]
      m.all_close(m2).should be_false
    end
  end

  it "inverts a Matrix" do
    m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
    inverse = Matrix.columns [[-2.0, 1.5], [1.0, -0.5]]

    m.invert!.all_close(inverse).should be_true
  end

  context "add rows" do
    it "adds a row at the beginning" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      new_row = [1.0] * m.number_of_cols

      new_m = m.prepend(new_row)

      new_m.should eq(Matrix.columns [[1.0, 1.0, 3.0], [1.0,2.0,4.0]])
    end

    it "adds a row at the middle" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      new_row = [1.0] * m.number_of_cols

      new_m = m.add_row(1, new_row)

      new_m.should eq(Matrix.columns [[1.0, 1.0, 3.0], [2.0,1.0,4.0]])
    end

    it "adds a row at the bottom" do
      m = Matrix.columns [[1.0, 3.0], [2.0, 4.0]]
      new_row = [1.0] * m.number_of_cols

      new_m = m.append(new_row)

      new_m.should eq(Matrix.columns [[1.0, 3.0, 1.0], [2.0,4.0,1.0]])
    end
  end
end
