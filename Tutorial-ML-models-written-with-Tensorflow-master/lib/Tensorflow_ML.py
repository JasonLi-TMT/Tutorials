import tensorflow as tf
import numpy as np
from tensorflow.contrib.tensor_forest.python import tensor_forest
from tensorflow.python.ops import resources




class linear_regression(object):
    def __init__(self, n_features):
        self.n_features = n_features
        self.learning_rate = 0.01
        self.params = {}
        self.sess = None

        self.X = tf.placeholder("float", shape=[None, self.n_features])
        self.Y = tf.placeholder("float")

        self.learning_rate = tf.placeholder("float")

        self.W = tf.Variable(np.random.randn(self.n_features, 1), name="Weight")
        self.b = tf.Variable(np.random.randn(), name="Bias")
        self.W = tf.cast(self.W, tf.float32)

        self.pred = tf.matmul(self.X, self.W) + self.b

        self.pred = tf.squeeze(self.pred)
        self.cost = tf.reduce_mean(tf.pow(self.Y - self.pred, 2))

        self.optimizer = tf.train.GradientDescentOptimizer(self.learning_rate).minimize(self.cost)

        self.init = tf.global_variables_initializer()

    def fit(self, x, y, learning_rate=0.01, epochs=10, display_freq=10):
        if x.shape[1] != self.n_features:
            raise Exception("n_features is not the same as input x features")
        if self.n_features == 1:
            x = x.reshape(-1, 1)
        if self.sess:
            pass
        else:
            self.sess = tf.Session()
            self.sess.run(self.init)

        dic_input = {self.X: x, self.Y: y, self.learning_rate: learning_rate}

        for epoch in range(epochs):

            self.sess.run(self.optimizer, feed_dict=dic_input)

            if epoch % display_freq == 0:
                _cost = self.sess.run(self.cost, feed_dict=dic_input)
                print("epoch:{}, cost:{}".format(epoch, _cost))

        self.params["Weight"] = self.sess.run(self.W)
        self.params["Bias"] = self.sess.run(self.b)

    def predict(self, x):

        y_pred = self.sess.run(self.pred, feed_dict={self.X: x})
        return y_pred


class logistic_regression(object):

    def __init__(self, num_features, num_output):

        self.X = tf.placeholder("float", shape=[None, num_features])
        self.Y = tf.placeholder("float", shape=[None, num_output])

        self.W = tf.Variable(tf.random_normal(shape=[num_features, num_output]))
        self.b = tf.Variable(tf.random_normal(shape=[num_output]))

        self.learning_rate = tf.placeholder("float")

        self.pred = tf.nn.softmax(tf.matmul(self.X, self.W) + self.b)

        self.cost = tf.reduce_mean(-tf.reduce_sum(self.Y * tf.log(self.pred), reduction_indices=1))

        self.optimizer = tf.train.GradientDescentOptimizer(self.learning_rate).minimize(self.cost)

        self.init = tf.global_variables_initializer()

        self.sess = None
        self.params = {}

    def fit(self, x, y, learning_rate=0.01, epochs=10, display_freq=10):
        if self.sess:
            pass
        else:
            self.sess = tf.Session()
            self.sess.run(self.init)

        dic_input = {self.X: x, self.Y: y, self.learning_rate: learning_rate}

        for epoch in range(epochs):

            self.sess.run(self.optimizer, feed_dict=dic_input)

            if epoch % display_freq == 0:
                _cost = self.sess.run(self.cost, feed_dict=dic_input)
                print("epoch:{}, cost:{}".format(epoch, _cost))

        self.params["Weight"] = self.sess.run(self.W)
        self.params["Bias"] = self.sess.run(self.b)


class randomforest(object):
    def __init__(self, num_features, num_classes, num_trees, max_nodes):
        tf.reset_default_graph()

        self.X = tf.placeholder(tf.float32, shape=[None, num_features])
        self.Y = tf.placeholder(tf.int32, shape=[None])

        self.hparams = tensor_forest.ForestHParams(num_classes=num_classes,
                                                   num_features=num_features,
                                                   num_trees=num_trees,
                                                   max_nodes=max_nodes).fill()
        print("test 1")
        # build graph
        self.forest_graph = tensor_forest.RandomForestGraphs(self.hparams)

        self.train_op = self.forest_graph.training_graph(self.X, self.Y)
        self.loss_op = self.forest_graph.training_loss(self.X, self.Y)

        infer_op, _, _ = self.forest_graph.inference_graph(self.X)
        self.infer_op = infer_op

        print("test 2")
        self.correct_pred = tf.equal(tf.argmax(self.infer_op, 1), tf.cast(self.Y, tf.int64))

        self.accuracy_op = tf.reduce_mean(tf.cast(self.correct_pred, tf.float32))

        self.init = tf.group(tf.global_variables_initializer(),
                             resources.initialize_resources(resources.shared_resources()))

        self.sess = None

    def fit(self, x, y, epochs=10, display_freq=10):
        if self.sess:
            pass
        else:
            self.sess = tf.Session()
            self.sess.run(self.init)

        dic_input = {self.X: x, self.Y: y}

        for epoch in range(epochs):

            _, l = self.sess.run([self.train_op, self.loss_op], feed_dict=dic_input)

            if epoch % display_freq == 0:
                acc = self.sess.run(self.accuracy_op, feed_dict=dic_input)
                print('Step %i, Loss: %f, Acc: %f' % (epoch, l, acc))


# class SVM(object):
    # def build_graph(self):
